enum English: String {
    case welCome_login = "Hi we are here to help you please login with your user id to sign. "
    case option2 = "Option 02 From Menu 01"
    case option3 = "Option 03 From Menu 01"
    case option4 = "Option 04 From Menu 01"
    case option5 = "Option 05 From Menu 01"
}

enum French: String {
    case welCome_login = "Option 01 From French 02"
    case option2 = "Option 02 From Menu 02"
    case option3 = "Option 03 From Menu 02"
    case option4 = "Option 04 From Menu 02"
    case option5 = "Option 05 From Menu 02"
}

enum Spanish: String {
    case welCome_login = "Option 01 From Spanish 02"
    case option2 = "Option 02 From Menu 02"
    case option3 = "Option 03 From Menu 02"
    case option4 = "Option 04 From Menu 02"
    case option5 = "Option 05 From Menu 02"
}


struct Menu
{
    enum LangType
    {
        case english (English)
        case french (French)
        case spanish (Spanish)
    }
    let type: LangType
    
    func justAnExample<T : RawRepresentable>(_ enumType: T.Type, _ str: String) where T.RawValue == String {

       // Note that an explicit use of init is required when creating an instance from a
       // metatype. We're also using a guard, as `init?(rawValue:)` is failable.
       guard let val = enumType.init(rawValue: str) else { return }
       print("description: \(val)")
     }
}


func handle(menu: Menu) -> String
{
    switch menu.type
    {
    case .english(let data): return data.rawValue
    case .french(let data): return data.rawValue
    case .spanish(let data): return data.rawValue
    }
}
