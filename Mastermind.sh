#!/bin/bash

GREEN='\e[0;32m'
YELLOW='\e[0;33m'
RED='\e[0;31m'
#Los colores para imprimir los resultados

turnos=10       #Número de intentos antes de perder
num=5           #Número de cifras de la clave
rep=False       #Admitir repetidos (True)
posicion=True   #Habilita el color amarillo (True)

mprin(){    #Inicializa el menú principal arrancando el juego entero
    op=10
    while true ; do   #Repite todo en bucle hasta introducir una opción válida
        clear
        echo "███╗░░░███╗░█████╗░░██████╗████████╗███████╗██████╗░███╗░░░███╗██╗███╗░░██╗██████╗░"
        echo "████╗░████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗████╗░████║██║████╗░██║██╔══██╗"
        echo "██╔████╔██║███████║╚█████╗░░░░██║░░░█████╗░░██████╔╝██╔████╔██║██║██╔██╗██║██║░░██║"
        echo "██║╚██╔╝██║██╔══██║░╚═══██╗░░░██║░░░██╔══╝░░██╔══██╗██║╚██╔╝██║██║██║╚████║██║░░██║"
        echo "██║░╚═╝░██║██║░░██║██████╔╝░░░██║░░░███████╗██║░░██║██║░╚═╝░██║██║██║░╚███║██████╔╝"
        echo "╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝╚═════╝░"
        echo
        echo "                              1--> NUEVO JUEGO                                     "
        echo "                              2--> CÓMO JUGAR                                      "
        echo "                              3-->  OPCIONES                                       "
        echo "                              4-->   SALIR                                         "
        echo
        echo "                            ¿QUÉ DESEAS HACER?                                     " 
        read op     #Lo que desee el jugador, lo mandará a distintos lugares

        case $op in
            1)
                clear
                gen
                chknum
                ;;
            2)
                clear
                guia
                read -p "Pulsa Intro para volver"
                ;;
            3)
                clear
                mopci
                read
                ;;
            4)
                clear
                exit
                ;;
            *)  
                echo "Opción inválida (Pulse Intro para volver)"
                read
                ;;
        esac
    done
}

gen(){      #Genera la clave en función del número de cifras configurado y si queremos repetidos o no
    cont=$num
    codigo=()
    if [[ $rep == "True" ]]
        then
            until [[ $cont -eq 0 ]]         #Hasta que el contador llegue a 0 seguirá añadiendo números a la lista que contiene la clave
                do
                    candidato=$((RANDOM%10))
                    codigo=("${codigo[@]}" $candidato)
                    ((cont--))
                done
        else
            until [[ $cont -eq 0 ]]
                do
                    candidato=$((RANDOM%10))
                    if ! [[ ${codigo[*]} =~ $candidato ]]   #Aquí comprueba que el número generado NO esté en la lista para añadirlo
                        then
                            codigo=("${codigo[@]}" $candidato)
                            ((cont--))
                    fi
                done
    fi
#    echo ${codigo[@]}   #Descomentar para ver la clave y ver que funciona
}

chknum(){       #Comprueba las cifras del numero del usuario con la clave y devuelve un resultado acorde
    v=0         #Ayuda a mandar a la victoria o derrota manteniendo el bucle de ejecución
    t=$turnos #Vuelco el valor de turnos para no modificarlo para futuras partidas
    t2=0    #Para sacar el final chulo si lo haces en menos de 5 turnos
    compara=${codigo[@]} #Empiezo el proceso de convertir a string
    compara=${compara//" "/""} #Elimino los espacios
    echo "¡Averigüe la clave numérica de $num cifras!"
    echo
    until [[ $t -eq 0 ]] ; do   #Los turnos a 0 marcan el final
        echo "Te quedan "$t intentos
        read -p "Introduzca un número: " intento
        resultado=()    #El resultado coloreado que se le mostrará al usuario
        if [[ $intento =~ ^[0-9]+$ ]]   #Comprueba que se pasen números
            then
                if [[ ${#intento} -eq $num ]]   #Comprueba que el número de cifras sea el adecuado
                    then
                        for ((i=0;i<${#codigo[@]};i++)) #Comienza un bucle tan largo como es la clave
                        do
                            if [[ ${intento:$i:1} == ${codigo[$i]} ]]   #Comprueba cifra y posición
                                then
                                    resultado=("${resultado[@]}" "${GREEN}${codigo[$i]}\e[0m")  #Si es correcto pinta el número de verde
                            elif echo ${codigo[@]} | grep -qw ${intento:$i:1} && [ $posicion == "True" ]; #Comprueba cifra en lista
                                then
                                    resultado=("${resultado[@]}" "${YELLOW}${intento:$i:1}\e[0m") #Sie stá en la lsita parece en amarillo
                                else
                                    resultado=("${resultado[@]}" "${RED}${intento:$i:1}\e[0m")    #Si el número no está, aparece en rojo
                            fi
                        done
                    else
                        echo
                        echo "¡La clave debe tener $num cifras!"
                        read -p "(Pulse Intro para continuar) " 
                fi
            else
                echo 
                echo "¡La clave solo puede conener números positivos!"
                read -p "(Pulse Intro para continuar) " 
        fi
    
    echo -e ${resultado[@]} #La -e es importante para que aparezcan los colores
    echo 
    ((t--))
    ((t2++))
        if [[ $intento == $compara ]]
            then
                v=1
                victoria
                break
        fi
    done
    if [[ $v != 1 ]]
        then
            derrota
    fi
}

victoria(){     #Muestra la pantalla de victoria y cierra el programa
    read -p "¡Enhorabuena, averiguaste la clave!(Pulsa intro para continuar)"
    clear
    if [[ $t2 -lt 6 ]]
        then
            echo "¡Y además lo has hecho super rápido!"; sleep 1
            echo "Estás hecho un crack, máquina, fiera,"; sleep 1
            echo "jefe, tifón, número uno, figura, mostro,";sleep 1
            echo "mastodonde, toro, furia, ciclón, tornado,"; sleep 1
            echo "artista, fenómeno, campeón, maestro, torero,"; sleep 1
            echo "socio, lince, tigre, tsunami, maremoto, volcán"; sleep 3
    fi
    clear
    echo "Tome su más que merecida medalla"; sleep 2
    clear
    echo " _______________"
    echo "|@@@@|     |####|"
    echo "|@@@@|     |####|"
    echo "|@@@@|     |####|"; sleep 1
    echo "\@@@@|     |####/"
    echo " \@@@|     |###/"
    echo "  \`@@|_____|##´"
    echo "       (O)"; sleep 1
    echo "    .-'''''-."
    echo "  .'  * * *  \`."
    echo " :  *       *  :"
    echo -e ": ~\e[1mM A S T E R\e[0m~ :"; sleep 1
    echo -e ": ~  \e[1mM I N D\e[0m  ~ :"
    echo " :  *       *  :"
    echo "  \`.  * * *  .'"
    echo "    \`-.....-'"; sleep 1
    echo
    read -p "Pulse Intro para volver "
    clear
}

derrota(){     #Muestra la pantalla de derrota y cierra el programa
    echo -e "Uy vaya, esto es incómodo\c"; sleep 1; echo -e ".\c"; sleep 1; echo -e ".\c"; sleep 1; echo "."
    read -p "(Pulse Intro para continuar) "
    clear
    echo "Te quedaste sin turnos"; sleep 1
    echo "Pero al menos lo intentaste"; sleep 1
    echo "Así que ahí te va una medalla"; sleep 2
    clear
    echo " _______________"
    echo "|@@@@|     |####|"
    echo "|@@@@|     |####|"
    echo "|@@@@|     |####|"; sleep 1
    echo "\@@@@|     |####/"
    echo " \@@@|     |###/"
    echo "  \`@@|_____|##´"
    echo "       (O)"; sleep 1
    echo "    .-'''''-."
    echo "  .'  * * *  \`."
    echo " :  *       *  :"
    echo -e ": ~\e[9mM A S T E R\e[0m~ :"
    echo -e ": ~   \e[3mY O U\e[0m   ~ :"; sleep 1
    echo -e ": ~  \e[9mM I N D\e[0m  ~ :"
    echo -e ": ~ \e[3mL O S E R\e[0m ~ :"
    echo " :  *       *  :"
    echo "  \`.  * * *  .'"
    echo "    \`-.....-'"; sleep 1
    echo
    read -p "Pulse Intro para volver"
    clear
}

guia(){     #Explica como funciona el juego
    echo -e "                              \e[1mBIENVENIDO A MASTERMIND\e[0m                    "
    echo "                                                                                   "
    echo "     Mastermind es un juego donde para ganar debes averiguar el código secreto,    "
    echo "       para lograr tal hazaña debes hacer uso del ingenio junto a la suerte.       "
    echo "                  ¿Podrás averiguarlo en menos de 5 intentos?                      "
    echo "                                                                                   "
    echo " Al introducir un número sus cifras se colorearán de distintos colores dependiendo "
    echo " de lo cerca que estés de dar con clave correcta:                                  "
    echo -e " ${GREEN}--> Verde si es correcto y está en su lugar.\e[0m                          "
    echo -e " ${YELLOW}--> Amarillo si es correcto PERO NO está en su lugar.\e[0m                "
    echo -e " ${RED}--> Rojo si es incorrecto (¡OJO, esto puede cambiar según la dificultad!)\e[0m"
    echo
    echo "    En el menú opciones puedes seleccionar la dificultad (por defecto es normal)   "
    echo "      Te animo a probar distintas dificultades ¡Incluso puedes personalizarla!     "
    echo "                   ¡Mucha suerte y espero que lo disfrutes!                        "
    echo
    
}

mopci(){    #Inicia el menú opciones
    while true ; do
        clear
        echo "                                   ╔══════════╗                                   "
        echo "                                   ║ OPCIONES ║                                   "
        echo "                                   ╚══════════╝                                   "
        echo
        echo "                                1-->      FÁCIL                                   "
        echo "                                2-->      NORMAL                                  "
        echo "                                3-->      DIFÍCIL                                 "
        echo "                                4-->    PERSONALIZADA                             "
        echo
        echo "                                ¿QUÉ DESEAS HACER?                                " 
        read op     #Lo que desee el jugador, lo mandará a distintos lugares

        case $op in
            1)
                clear
                facil
                echo "Dicultad FÁCIL establecida (Pulse Intro para continuar)"
                break
                ;;
            2)
                clear
                normal
                echo "Dicultad NORMAL establecida (Pulse Intro para continuar)"
                break
                ;;
            3)
                clear
                dificil
                echo "Dicultad DIFÍCIL establecida (Pulse Intro para continuar)"
                break
                ;;
            4)
                clear
                personalizada
                break
                ;;
            *)
                echo "Opción inválida (Pulse Intro para continuar)"
                read
                ;;
        esac
    done
}

facil(){            #Establece la dificultad en modo fácil
    echo "Número de turnos:   10"
    echo "Número de cifras:    3"
    echo "Cifras repetidas:   NO"
    echo "Habilitar amarillo: SI"
    echo
    turnos=10
    num=3
    rep=False
    posicion=True
}

normal(){           #Establece la dificultad en modo normal
    echo "Número de turnos:   10"
    echo "Número de cifras:    5"
    echo "Cifras repetidas:   SI"
    echo "Habilitar amarillo: SI"
    echo
    turnos=10
    num=5
    rep=True
    posicion=True
}

dificil(){          #Establece la dificultad en modo dificil
    echo "Número de turnos:   10"
    echo "Número de cifras:    7"
    echo "Cifras repetidas:   SI"
    echo "Habilitar amarillo: NO"
    echo
    turnos=10
    num=7
    rep=True
    posicion=False
}

personalizada(){    #Permite personalizar valor por valor la dificultad
    chk=True        #Permite comprobar si hay algún fallo
    pos=50
    repe=50
    while true ; do

    read -p "Introduce el número de turnos: " turn
    if [[ $(($turn)) -gt 0 ]]    #Comprueba que el número de turnos tenga un valor positivo
        then
            echo "Valor aceptado"
        else
            echo "Valor erróneo detectado (Pulse Intro para continuar)"
            chk=False
            break
    fi

    read -p "Introduce el número de cifras (Máx 10): " cif
    if [[ $(($cif)) -gt 0 ]] && [[ $(($cif)) -lt 11 ]]    #Comprueba que el número de cifras tenga un valor positivo
        then
            echo "Valor aceptado"
        else
            echo "Valor erróneo detectado (Pulse Intro para continuar)"
            chk=False
            break
    fi

    echo "¿Quieres números repetidos?"
    read -p "0 -> NO | 1 -> SI: " repe
    if [[ $(($repe)) -eq 1 ]] || [[ $(($repe)) -eq 0 ]]     # Uso valores de 0 y 1 para configurar el booleano de las repeticiones
        then
            echo "Valor aceptado"
        else
            echo "Valor erróneo detectado (Pulse Intro para continuar)"
            chk=False
            break
    fi

    echo "¿Quieres habilitar el color amarillo?"
    read -p "0 -> NO | 1 -> SI: " pos
    pos=${pos:-50}
    read -p "$pos"
    if [[ $(($pos)) -eq 1 ]] || [[ $(($pos)) -eq 0 ]]     #Comprueba que el número de cifras tenga un valor positivo
        then
            break
        else
            echo "Valor erróneo detectado (Pulse Intro para continuar)"
            chk="False"
            break
    fi
    done
    if [[ $chk == "True" ]]
        then        
            clear
            turnos=$turn
            echo "Número de turnos:   $turn"
            num=$cif
            echo "Número de cifras:    $cif"
            if [[ $(($repe)) -eq 1 ]]
                then
                    rep=True
                    echo "Cifras repetidas:   SI"
                else
                    rep=False
                    echo "Cifras repetidas:   NO"
            fi
            if [[ $(($pos)) -eq 1 ]]
                then
                    posicion=True
                    echo "Habilitar amarillo: SI"
                else
                    posicion=False
                    echo "Habilitar amarillo: NO"
            fi
            echo
            echo "Opción PERSONALIZADA establecida (Pulse Intro para continuar)"
    fi
}

mprin
