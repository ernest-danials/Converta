//
//  Constants.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

enum TabViewItems: String, CaseIterable {
    case Home, Library, Historical
    case CurrencyCodes = "Currency Codes"
    case Settings
    
    func getImageName() -> String {
        switch self {
        case .Home:
            return "house"
        case .Library:
            return "rectangle.stack.badge.person.crop" // "rectangle.stack"
        case .Historical:
            return "clock.arrow.circlepath"
        case .CurrencyCodes:
            return "dollarsign.circle"
        case .Settings:
            return "gearshape"
        }
    }
}

enum AppearanceMode: String, CaseIterable {
    case device = "Device Settings"
    case light = "Light"
    case dark = "Dark"
    
    func getColorScheme() -> ColorScheme? {
        switch self {
        case .device:
            return .none
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .device:
            return "iphone"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}

enum Tips: CaseIterable {
    case kindTip, greatTip, amazingTip, wonderfulTip, outrageousTip
    
    func getTip() -> Tip {
        switch self {
        case .kindTip:
            return .init(name: "Kind Tip", emoji: "🙂", amountInWon: "￦1,000", price: 1000)
        case .greatTip:
            return .init(name: "Great Tip", emoji: "😊", amountInWon: "￦2,000", price: 2000)
        case .amazingTip:
            return .init(name: "Amazing Tip", emoji: "😆", amountInWon: "￦5,000", price: 5000)
        case .wonderfulTip:
            return .init(name: "Wonderful Tip", emoji: "🤩", amountInWon: "￦10,000", price: 10000)
        case .outrageousTip:
            return .init(name: "Outrageous Tip", emoji: "🤯", amountInWon: "￦50,000", price: 50000)
        }
    }
}

struct Tip: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let amountInWon: String
    let price: Int
}

enum AppIcon: String, CaseIterable, Identifiable {
    case icon = "AppIcon-icon"
    case lightMode = "AppIcon-light"
    case darkMode = "AppIcon-dark"
    case letter = "AppIcon-letter"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .icon:
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .lightMode:
            return "Icon with Converta logo (Light)"
        case .darkMode:
            return "Icon with Converta logo (Dark)"
        case .icon:
            return "Icon with Converta icon"
        case .letter:
            return "Icon with Converta's initial letter"
        }
    }

    #if os(iOS)
    var preview: UIImage {
        UIImage(named: rawValue + "-preview") ?? UIImage()
    }
    #endif
}

enum LicenseTexts: String {
    case ActivityIndicatorView =
    """
    MIT License

    Copyright (c) 2020 exyte <info@exyte.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE."
    """
}

enum CurrencyCode: String, AppStorageConvertible, CaseIterable {
    case UnitedArabEmiratesDirham = "AED"
    case AfghanAfghani = "AFN"
    case AlbanianLek = "ALL"
    case ArmenianDram = "AMD"
    case AngolanKwanza = "AOA"
    case ArgentinePeso = "ARS"
    case AustralianDollar = "AUD"
    case ArubanFlorin = "AWG"
    case AzerbaijaniManat = "AZN"
    case BosniaHerzegovinaConvertibleMark = "BAM"
    case BarbadianDollar = "BBD"
    case BangladeshiTaka = "BDT"
    case BulgarianLev = "BGN"
    case BahrainiDinar = "BHD"
    case BurundianFranc = "BIF"
    case BermudanDollar = "BMD"
    case BruneiDollar = "BND"
    case BolivianBoliviano = "BOB"
    case BrazilianReal = "BRL"
    case BahamianDollar = "BSD"
    case BhutaneseNgultrum = "BTN"
    case BotswananPula = "BWP"
    case Belarusianruble = "BYN"
    case BelarusianRuble = "BYR"
    case BelizeDollar = "BZD"
    case CanadianDollar = "CAD"
    case CongoleseFranc = "CDF"
    case SwissFranc = "CHF"
    case UnidaddeFomento = "CLF"
    case ChileanPeso = "CLP"
    case ChineseYuan = "CNY"
    case CoombianPeso = "COP"
    case CostaRicanColón = "CRC"
    case CubanConvertiblePeso = "CUC"
    case CubanPeso = "CUP"
    case CapeVerdeanEscudo = "CVE"
    case CzechRepublicKoruna = "CZK"
    case DjiboutianFranc = "DJF"
    case DanishKrone = "DKK"
    case DominicanPeso = "DOP"
    case AlgerianDinar = "DZD"
    case EgyptianPound = "EGP"
    case EritreanNakfa = "ERN"
    case EthiopianBirr = "ETB"
    case Euro = "EUR"
    case FijianDollar = "FJD"
    case FalklandIslandsPound = "FKP"
    case BritishPoundSterling = "GBP"
    case GeorgianLari = "GEL"
    case Guernseypound = "GGP"
    case GhanaianCedi = "GHS"
    case GibraltarPound = "GIP"
    case GambianDalasi = "GMD"
    case GuineanFranc = "GNF"
    case GuatemalanQuetzal = "GTQ"
    case GuyanaeseDollar = "GYD"
    case HongKongDollar = "HKD"
    case HonduranLempira = "HNL"
    case CroatianKuna = "HRK"
    case HaitianGourde = "HTG"
    case HungarianForint = "HUF"
    case IndonesianRupiah = "IDR"
    case IsraeliNewSheqel = "ILS"
    case Manxpound = "IMP"
    case IndianRupee = "INR"
    case IraqiDinar = "IQD"
    case IranianRial = "IRR"
    case IcelandicKróna = "ISK"
    case Jerseypound = "JEP"
    case JamaicanDollar = "JMD"
    case JordanianDinar = "JOD"
    case JapaneseYen = "JPY"
    case KenyanShilling = "KES"
    case KyrgystaniSom = "KGS"
    case CambodianRiel = "KHR"
    case ComorianFranc = "KMF"
    case NorthKoreanWon = "KPW"
    case SouthKoreanWon = "KRW"
    case KuwaitiDinar = "KWD"
    case CaymanIslandsDollar = "KYD"
    case KazakhstaniTenge = "KZT"
    case LaotianKip = "LAK"
    case LebanesePound = "LBP"
    case SriLankanRupee = "LKR"
    case LiberianDollar = "LRD"
    case LesothoLoti = "LSL"
    case LithuanianLitas = "LTL"
    case LatvianLats = "LVL"
    case LibyanDinar = "LYD"
    case MoroccanDirham = "MAD"
    case MoldovanLeu = "MDL"
    case MalagasyAriary = "MGA"
    case MacedonianDenar = "MKD"
    case MyanmaKyat = "MMK"
    case MongolianTugrik = "MNT"
    case MacanesePataca = "MOP"
    case MauritanianOuguiya = "MRO"
    case MauritianRupee = "MUR"
    case MaldivianRufiyaa = "MVR"
    case MalawianKwacha = "MWK"
    case MexicanPeso = "MXN"
    case MalaysianRinggit = "MYR"
    case MozambicanMetical = "MZN"
    case NamibianDollar = "NAD"
    case NigerianNaira = "NGN"
    case NicaraguanCórdoba = "NIO"
    case NorwegianKrone = "NOK"
    case NepaleseRupee = "NPR"
    case NewZealandDollar = "NZD"
    case OmaniRial = "OMR"
    case PanamanianBalboa = "PAB"
    case PeruvianNuevoSol = "PEN"
    case PapuaNewGuineanKina = "PGK"
    case PhilippinePeso = "PHP"
    case PakistaniRupee = "PKR"
    case PolishZloty = "PLN"
    case ParaguayanGuarani = "PYG"
    case QatariRial = "QAR"
    case RomanianLeu = "RON"
    case SerbianDinar = "RSD"
    case RussianRuble = "RUB"
    case RwandanFranc = "RWF"
    case SaudiRiyal = "SAR"
    case SolomonIslandsDollar = "SBD"
    case SeychelloisRupee = "SCR"
    case SudanesePound = "SDG"
    case SwedishKrona = "SEK"
    case SingaporeDollar = "SGD"
    case SaintHelenaPound = "SHP"
    case SierraLeoneanLeone = "SLL"
    case SomaliShilling = "SOS"
    case SurinameseDollar = "SRD"
    case SãoToméandPríncipedobra = "STD"
    case SalvadoranColón = "SVC"
    case SyrianPound = "SYP"
    case SwaziLilangeni = "SZL"
    case ThaiBaht = "THB"
    case TajikistaniSomoni = "TJS"
    case TurkmenistaniManat = "TMT"
    case TunisianDinar = "TND"
    case TonganPaʻanga = "TOP"
    case TurkishLira = "TRY"
    case TrinidadandTobagoDollar = "TTD"
    case NewTaiwanDollar = "TWD"
    case TanzanianShilling = "TZS"
    case UkrainianHryvnia = "UAH"
    case UgandanShilling = "UGX"
    case USDollar = "USD"
    case UruguayanPeso = "UYU"
    case UzbekistanSom = "UZS"
    case VenezuelanBolívar = "VEF"
    case VietnameseDong = "VND"
    case VanuatuVatu = "VUV"
    case SamoanTala = "WST"
    case YemeniRial = "YER"
    case SouthAfricanRand = "ZAR"
    case ZambianKwachaZMK = "ZMK"
    case ZambianKwachaZMW = "ZMW"
    case ZimbabweanDollar = "ZWL"
}
