# Registro Pillole

Applicazione nativa per iPhone e Apple Watch per registrare le pressioni sui pulsanti **EUTIROX** e **BLOPRESS**.

## Funzioni incluse nella prima versione

- Pulsanti dedicati EUTIROX e BLOPRESS su iPhone e Apple Watch.
- Registrazione di data e ora a ogni pressione.
- Storico suddiviso per giornata.
- Eliminazione di una registrazione errata tramite gesto di scorrimento.
- Salvataggio locale su ciascun dispositivo.
- Sincronizzazione tra iPhone e Apple Watch tramite WatchConnectivity.
- App Watch configurata per poter funzionare anche quando l'iPhone non è immediatamente disponibile.

> L'app registra esclusivamente la pressione del pulsante: non può verificare che il medicinale sia stato effettivamente assunto. Non costituisce un promemoria clinico e non sostituisce prescrizioni o indicazioni del medico.

## Struttura del progetto

- `Shared/`: modello dati, archivio locale e sincronizzazione.
- `Sources/iOS/`: applicazione iPhone.
- `Sources/Watch/`: applicazione Apple Watch.
- `project.yml`: configurazione XcodeGen.
- `.github/workflows/build.yml`: compilazione automatica su macOS GitHub Actions.

## Compilazione

Il progetto Xcode viene generato con XcodeGen:

```bash
brew install xcodegen
xcodegen generate
```

Aprire quindi `RegistroPillole.xcodeproj` in Xcode.

La compilazione automatica viene avviata a ogni push sul branch `main` e può essere consultata nella scheda **Actions** del repository. La firma e l'installazione sui dispositivi fisici richiedono un account Apple configurato in Xcode e dispositivi abbinati.

## Privacy

Il repository contiene codice sorgente, non registrazioni di assunzioni. Non inserire dati sanitari personali, credenziali o registrazioni reali nei file pubblici. Gli eventi dell'app vengono conservati localmente sui dispositivi e trasferiti tra i dispositivi abbinati tramite WatchConnectivity.
