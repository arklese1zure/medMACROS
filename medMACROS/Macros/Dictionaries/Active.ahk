; MEDIMACROSADDON
;=============================================================================================================================================================
; Diccionario para MediMacros
;=============================================================================================================================================================

;##ESTRUCTURA DE LAS EXTENSIONES PARA MEDIMACROS##############################################################################################################
; El formato de las extensiones para mediMACROS es simplemente un script de AutoHotkey con algunas subrutinas predeterminadas que el script principal
; usa para agregar funcionalidad en el lugar correcto. Todas las subrutinas que est�n en la plantilla para extensiones deben estar presentes aunque
; no se vayan a usar en la extensi�n que se est� creando.
; Si no se requiere alguna subrutina, se debe dejar el nombre y el elemento "return", de modo que el script contin�e con su estructura.
;#############################################################################################################################################################

DictReadSettings: ;==Variables para configurar mediMACROS====================================================================================================
dict_Name :=					"Abreviaturas sin dosis"					; Nombre de la extensi�n, no debe usar caracteres especiales.
return																		; regresar

:R:DM2::Diabetes mellitus tipo 2
:R:DM1::Diabetes mellitus tipo 1
:R:AR::Artritis reumatoide
:R:SOP::S�ndrome de ovario poliqu�stico
:R:EAD::Enfermedad articular degenerativa
:R:HPB::Hiperplasia prost�tica benigna
:R:ERC::Enfermedad renal cr�nica
:R:LUES::Lupus eritematoso sist�mico
:R:ALZHEIMER::Enfermedad de alzheimer
:R:CUCI::Colitis ulcerosa cr�nica inespec�fica
:R:CAMAMA::C�ncer de mama
:R:FA::Fibrilaci�n auricular
:R:LABS::laboratorios
:R:PFH::pruebas de funci�n hep�tica
:R:BH::biometr�a hem�tica
:R:QS::qu�mica sangu�nea
:R:HBA1C::hemoglobina glucosilada
:R:VSG::velocidad de sedimentaci�n globular
:R:MHD::medidas higi�nico-diet�ticas
:R:MTF::metformina
:R:ASA300::Acido acetilsalic�lico soluble
:R:OMP::Omeprazol
:R:CLONA::Clonazepam
:R:FEXO::Fexofenadina
:R:PREGA::Pregabalina
:R:COMB::Complejo B
:R:LOSARTAN::Losartan
:R:MTP::Metoprolol
:R:HCTZ::Hidroclorotiazida
:R:DX::Diagn�stico
:R:PENTO::Pentoxifilina
:R:FURO::Furosemide
:R:TAMSU::Tamsulosina
:R:VILDA::Vildagliptina
:R:BEZA::Bezafibrato
:R:CLOPI::Clopidogrel
:R:TELMI::Telmisartan
:R:AMLO::Amlodipino
:R:PIOG::Pioglitazona
:R:BUPRE::Buprenorfina
:R:LEVOT::Levotiroxina
:R:ATOR::Atorvastatina
:R:TELMI::Telmisartan
:R:IRBE::Irbesartan
:R:SERTRA::Sertralina
:R:ENP::Enalapril
:R:Z125::Examen de pesquisa especial para tumor de la pr�stata
:R:Z131::Examen de pesquisa especial para diabetes mellitus
:R:FUM::fecha de �ltima menstruaci�n
:R:FPP::fecha probable de parto
:R:AFU::altura de fondo uterino
:R:FCF::frecuencia card�aca fetal
:R:LPM::latidos por minuto
:R:SDG::semanas de gestaci�n
:R:EGO::examen general de orina
:R:O098::Supervisi�n de embarazo de alto riesgo
:R:AOC::anticonceptivo oral combinado
:R:idx::impresi�n diagn�stica
:R:RX::radiograf�a
:R:PX::paciente
:R:DBP::diametro biparietal
:R:Z716::Consulta para asesor�a por abuso de tabaco
:R:Z340::Contacto para supervisi�n del primer embarazo normal, trimestre no especificado 
:R:Z349::Contacto para supervisi�n del embarazo normal, no especificado, trimestre no especificado 
:R:PC::per�metro cef�lico
:R:pa::per�metro abdominal
:R:lf::longitud femoral
:R:aprox::aproximadamente
:R:puvi::producto �nico vivo intrauterino
:R:HAS::Hipertensi�n esencial (primaria)
:R:O100::Hipertensi�n preexistente que complica el embarazo, parto y puerperio
:R:O139:: Hipertensi�n gestacional sin proteinuria significativa
:R:O095::Supervisi�n de multigr�vida a�osa
:R:rots::reflejos osteotendinosos
