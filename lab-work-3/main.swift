import Foundation

struct Student {
    let firstName: String
    let lastName: String
    var averageGrade: Double
    
    init(firstName: String, lastName: String, averageGrade: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.averageGrade = averageGrade
    }
}

struct StudentJournal {
    var students: [Student] = []
    
    mutating func addStudent(_ student: Student) {
        students.append(student)
    }
    
    mutating func removeStudent(firstName: String, lastName: String) throws {
        guard let index = students.firstIndex(where: { $0.firstName == firstName && $0.lastName == lastName }) else {
            throw StudentJournalError.studentNotFound
        }
        students.remove(at: index)
    }
    
    func displayStudents() {
        for student in students {
            print("Имя: \(student.firstName) \(student.lastName), Средний балл: \(student.averageGrade)")
        }
    }
    
    func listStudentsByGPA() {
        let sortedStudents = students.sorted(by: { $0.averageGrade > $1.averageGrade })
        for student in sortedStudents {
            print("Имя: \(student.firstName) \(student.lastName), Средний балл: \(student.averageGrade)")
        }
    }
    
    func averageGradeOfAllStudents() -> Double {
        let total = students.reduce(0.0) { $0 + $1.averageGrade }
        return total / Double(students.count)
    }
    
    func studentWithHighestGPA() -> Student? {
        return students.max(by: { $0.averageGrade < $1.averageGrade })
    }
}

enum StudentJournalError: Error {
    case studentNotFound
}

func displayMenu() {
    print("Выберите действие:")
    print("1. Добавить студента")
    print("2. Удалить студента")
    print("3. Вывести список студентов")
    print("4. Вывести список студентов по среднему баллу")
    print("5. Вывести средний балл всех студентов")
    print("6. Найти студента с самым высоким средним баллом")
    print("7. Выйти")
}

func getInput() -> String {
    print("Введите ваш выбор: ", terminator: "")
    return readLine() ?? ""
}

func addStudent(journal: inout StudentJournal) {
    print("Введите имя студента: ", terminator: "")
    let firstName = readLine() ?? ""
    print("Введите фамилию студента: ", terminator: "")
    let lastName = readLine() ?? ""
    print("Введите средний балл студента: ", terminator: "")
    if let averageGrade = Double(readLine() ?? "") {
        journal.addStudent(Student(firstName: firstName, lastName: lastName, averageGrade: averageGrade))
        print("Студент успешно добавлен.")
    } else {
        print("Неверный формат среднего балла.")
    }
}

func removeStudent(journal: inout StudentJournal) {
    print("Введите имя студента: ", terminator: "")
    let firstName = readLine() ?? ""
    print("Введите фамилию студента: ", terminator: "")
    let lastName = readLine() ?? ""
    do {
        try journal.removeStudent(firstName: firstName, lastName: lastName)
        print("Студент успешно удален.")
    } catch StudentJournalError.studentNotFound {
        print("Студент не найден.")
    } catch {
        print("Произошла неизвестная ошибка.")
    }
}

func main() {
    var journal = StudentJournal()
    var quit = false
    
    while !quit {
        displayMenu()
        let choice = getInput()
        
        switch choice {
        case "1":
            addStudent(journal: &journal)
        case "2":
            removeStudent(journal: &journal)
        case "3":
            print("Список студентов:")
            journal.displayStudents()
        case "4":
            print("Список студентов по среднему баллу:")
            journal.listStudentsByGPA()
        case "5":
            let averageGrade = journal.averageGradeOfAllStudents()
            print("Средний балл всех студентов: \(averageGrade)")
        case "6":
            if let highestGPAStudent = journal.studentWithHighestGPA() {
                print("Студент с самым высоким средним баллом: \(highestGPAStudent.firstName) \(highestGPAStudent.lastName), Средний балл: \(highestGPAStudent.averageGrade)")
            } else {
                print("Студенты не найдены.")
            }
        case "7":
            quit = true
        default:
            print("Неверный выбор. Пожалуйста, выберите пункт меню от 1 до 7.")
        }
        
        print()
    }
    
    print("До свидания!")
}

main()
