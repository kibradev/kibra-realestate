KIBRA = {}

KIBRA.EmlakJob = "emlak" -- Emlakçıya Erişebilecek Mesleğin Adı
KIBRA.HouseSales = true -- Emlakçının Ev Satabilmesini Sağlar.
KIBRA.EmlakChangeNamePrice = 1000 -- Emlakçı Dükkanı'nın adını değiştirme bedeli
KIBRA.BlackMoneyWash = true -- True olması durumunda emlakçı karapara aklayabilir.
KIBRA.BlackMoneyWashPrice = 2 -- Aklayacağı parayı belirtilen sayıya böler.

KIBRA.EmlakBlip = {
    BlipCoord = vector3(-707.39, 268.16, 83.15),
    BlipId = 476,
    BlipColor = 1,
    BlipSize = 0.6,
    BlipShow = true
}

KIBRA.EmlakCoords = vector3(-715.98, 261.26, 83.93)
KIBRA.EmlakDepo = vector3(-718.68, 260.8, 83.81)

KIBRA.EmlakDoorLock = {
    [1] = {
        DoorHash = 1901183774,
        DoorHeading = 301.16,
        DoorCoord = vector3(-714.33, 265.11, 84.1),
        DoorLock = true,
    },

    [2] = {
        DoorHash = 1901183774,
        DoorHeading = 296.61,
        DoorCoord = vector3(-716.62, 271.33, 84.7),
        DoorLock = true,
    }
}

