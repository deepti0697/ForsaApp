//
//  Messages.swift
//  AppTemplate
//
//  Created by admin on 15/01/19.
//  Copyright © 2019 dotsquare. All rights reserved.
//

import Foundation


import Foundation
let kAppName            = "FORSA"


let kHMYMDFormate         = "yyyy-MM-dd HH:mm:ss"
let kDateFormate          =  "dd-MMM-yyyy"
let kDateFormate2          =  "dd MMM yyyy"
let kDateFormateAPI       =  "yyyy-MM-dd"
let kUTC_time_zone_format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//2020-05-23T13:18:50.000Z


var kWindow = UIWindow(frame: UIScreen.main.bounds)
let kApplicationDelegate = UIApplication.shared.delegate as! AppDelegate
var kScreenSize         = UIScreen.main.bounds.size


enum Messages : String {
    case NAME_EMPTY             = "Please enter full name."
    case SURNAME                = "Please enter first name."
    case LASTNAME               = "Please enter last name."
    case EMAIL_EMPTY            = "Please enter Email/Username."
    case EMAIL_INVALID          = "Please enter correct email address."
    case FULL_NAME_LENGTH       = "Full name should be minimum 3 characters. "
    case PASSWORD_EMPTY         = "Please enter password."
    case NEW_PASSWORD_EMPTY     = "Please enter new password."
    case EMAIL_NUMBER           = "Please enter email/mobile number. "
    case QUERY_TITLE            = "Please enter title. "
    case TICK_ALLOW          = "Please agree to terms and conditions & policy "
    //Password
    case OLD_PASSWORD_EMPTY     = "Old password field can not be blank."
    case CONFIRM_PASSWORD_EMPTY = "Please enter confirm password."
    case PASSWORD_DIFFERENT     = "New password did not match with confirm password."
    case VERIFICATION_CODE      = "Please enter correct verificaton code."
    case LOGOUT                 = "Are you sure you want to logout?"
    case LANG_EMPTY             = "PLease select language"
      case COUNTRY_EMPTY             = "Please select country"
    case report                 = "Are you sure you want to report?"
    case CARD_TYPE              = "Please select card type."
    case CARD_LENGTH            = "Please enter valid card number."
    case CARD_CVV               = "Please enter CVV number."
    case EXPIRY_DATE            = "PLease select expiration date."
    case CARD_EMPTY             = "Please enter card number."
    case PHONE_EMPTY            = "Please enter phone number."
    case PHONE_Code             = "Please select mobile code."
    case PHONE_INVALID          = "Please enter correct phone number."
    case AMOUNT                 = "Please enter amount."
    case DOB_ERROR              = "Please enter your date of birth"
    case SUBJECT                = "Please enter subject."
    case REQUESTDATA            = "Please enter request data."
    case PASSWORD_LENGTH        = "Password should be minimum 4 digits"
    case NEW_PASSWORD_LENGTH    = "New password should be minimum 4 digits"
    case PHONE_NUMBER           = "Enter valid phone number."
    case PASSWORD_OLD_EMPTY     = "Please enter old password."
    case PASSWORD_MATCH         = "Password should be same."
    case INTERNET_ERROR         = "Please check your internet connection"
    case GENDER_ERROR           = "Please select your gender"
    case LOCATION               = "Please enter your location"
    case ABOUT                  = "Please enter about you"
    case INTERESTAREA           = "Please select at least one interest area"
}


enum MessageSpanish : String {
    
    case NAME_EMPTY             = "Por favor, introduzca el nombre completo"
    case SURNAME                = "Por favor, introduzca el nombre"
    case LASTNAME               = "Por favor, introduzca el apellido"
    case EMAIL_EMPTY            = "Ingrese la dirección de correo electrónico"
    case EMAIL_INVALID          = "Ingrese la dirección de correo electrónico correcta"
    case FULL_NAME_LENGTH       = "El nombre completo debe tener un mínimo de 2 caracteres"
    case PASSWORD_EMPTY         = "Por favor, ingrese contraseña."
    case NEW_PASSWORD_EMPTY     = "Por favor, introduzca una nueva contraseña"
    case COUNTRY_NAME           = "Por favor seleccione país"
    case EMAIL_NUMBER           = "Ingrese el correo electrónico / número de teléfono móvil"
    case QUERY_TITLE            = "Por favor, introduzca el título"
    case QUERY_message          = "Por favor ingrese el mensaje"
    //Password
    case OLD_PASSWORD_EMPTY     = "El campo de contraseña anterior no puede estar en blanco"
    case CONFIRM_PASSWORD_EMPTY = "Ingrese la contraseña de confirmación."
    case PASSWORD_DIFFERENT     = "La nueva contraseña no coincide con el pase de confirmaciósword."
    case VERIFICATION_CODE      = "Ingrese el código de verificación correcto"
    case LOGOUT                 = "¿Estás seguro de que quieres cerrar sesión?"
    case Text_Enter             = "Por favor ingrese el texto"
    case report                 = "¿Estás seguro de que quieres reportar?"
    case CARD_TYPE              = "Seleccione el tipo de tarjeta"
    case CARD_LENGTH            = "Ingrese un número de tarjeta válido"
    case CARD_CVV               = "Ingrese el número CVV"
    case EXPIRY_DATE            = "Por favor seleccione la fecha de vencimiento"
    case CARD_EMPTY             = "Ingrese el número de tarjeta"
    case PHONE_EMPTY            = "Ingrese el número de teléfono móvil"
    case PHONE_Code             = "Seleccione el código móvil"
    case PHONE_INVALID          = "Ingrese el número de teléfono móvil correcto"
    case AMOUNT                 = "Ingrese el monto"
    case DOB_ERROR              = "Por favor, introduzca su fecha de nacimiento"
    case SUBJECT                = "Ingrese el asunto"
    case REQUESTDATA            = "Ingrese los datos de la solicitud"
    case PASSWORD_LENGTH        = "La contraseña debe tener un mínimo de 4 dígitos"
    case NEW_PASSWORD_LENGTH    = "La nueva contraseña debe tener un mínimo de 4 dígitos"
    case PHONE_NUMBER           = "Ingrese un número de teléfono válido"
    case PASSWORD_OLD_EMPTY     = "Ingrese la contraseña anterior"
    case PASSWORD_MATCH         = "La contraseña debe ser la misma"
    case INTERNET_ERROR         = "Por favor revise su conexion a internet"
    case GENDER_ERROR           = "Por favor seleccione su género"
    case LOCATION               = "Por favor ingrese su ubicación"
    case ABOUT                  = "Por favor, escribe sobre ti"
    case INTERESTAREA           = "Seleccione al menos un área de interés"
    
    
}



enum MessageFrench : String {
                                     
    case NAME_EMPTY             = "Veuillez saisir le nom complet."
    case SURNAME                = "Veuillez saisir votre prénom."
    case LASTNAME               = "Veuillez saisir votre nom."
    case EMAIL_EMPTY            = "Veuillez saisir votre adresse e-mail."
    case EMAIL_INVALID          = "Veuillez saisir une adresse e-mail correcte."
    case FULL_NAME_LENGTH       = "Le nom complet doit contenir au moins 2 caractères."
    case PASSWORD_EMPTY         = "Veuillez entrer le mot de passe."
    case NEW_PASSWORD_EMPTY     = "Veuillez saisir un nouveau mot de passe."
    case COUNTRY_NAME           = "Veuillez sélectionner un pays"
    case EMAIL_NUMBER           = "Veuillez saisir votre e-mail / numéro de mobile."
    case QUERY_TITLE            = "Veuillez entrer le titre. "
    case QUERY_message          = "Veuillez saisir un message."
    case OLD_PASSWORD_EMPTY     = "Le champ de l'ancien mot de passe ne peut pas être vide."
    case CONFIRM_PASSWORD_EMPTY = "Veuillez entrer le mot de passe de confirmation .."
    case PASSWORD_DIFFERENT     = "Le nouveau mot de passe ne correspond pas au mot de passe de confirmation."
    case VERIFICATION_CODE      = "Veuillez entrer le bon code de vérification."
    case LOGOUT                 = "Êtes-vous sûr de vouloir vous déconnecter?"
    case Text_Enter             = "Veuillez saisir du texte."
    case report                 = "Êtes-vous sûr de vouloir signaler?"
    case CARD_TYPE              = "Veuillez sélectionner le type de carte."
    case CARD_LENGTH            = "Veuillez saisir un numéro de carte valide."
    case CARD_CVV               = "Veuillez saisir le numéro CVV."
    case EXPIRY_DATE            = "Veuillez sélectionner la date d'expiration."
    case CARD_EMPTY             = "Veuillez entrer le numéro de la carte."
    case PHONE_EMPTY            = "Veuillez entrer le numéro de portable."
    case PHONE_Code             = "Veuillez sélectionner le code mobile."
    case PHONE_INVALID          = "Veuillez saisir le bon numéro de portable."
    case AMOUNT                 = "Veuillez saisir le montant."
    case DOB_ERROR              = "Veuillez entrer votre date de naissance"
    case SUBJECT                = "Veuillez entrer le sujet."
    case REQUESTDATA            = "Veuillez saisir les données de la demande."
    case PASSWORD_LENGTH        = "Le mot de passe doit contenir au moins 4 chiffres"
    case NEW_PASSWORD_LENGTH    = "Le nouveau mot de passe doit comporter au moins 4 chiffres"
    case PHONE_NUMBER           = "Entrez un numéro de téléphone valide."
    case PASSWORD_OLD_EMPTY     = "Veuillez entrer l'ancien mot de passe."
    case PASSWORD_MATCH         = "Le mot de passe devrait être le même."
    case INTERNET_ERROR         = "S'il vous plait, vérifiez votre connexion internet"
    case GENDER_ERROR           = "S'il vous plait selectionnez votre genre"
    case LOCATION               = "Veuillez entrer votre emplacement"
    case ABOUT                  = "Veuillez entrer pour vous"
    case INTERESTAREA           = "Veuillez sélectionner au moins un domaine d'intérêt"
     
    
}



public enum AlertButton: String {
    case OK     = "OK"
    case CANCEL = "Cancel"
    case YES    = "Yes"
    case NO     = "No"
    case CAMERA = "Camera"
    case PHOTOS = "Photo Library"
}


