def setTap(value: int):
	print("sets LFSR state to the given value")

def setLFSR(value: int):
	print("sets LFSR state to the given value")

def next():
	print("gets the next LFSR state")

def isRightTap(tap):
	print("perform tap calculation and compares to newLFSR")

def decode(encodedArray: list):
	# Find Tap
	tapArray = [0x60, 0x48, 0x78, 0x72, 0x6A, 0x69, 0x5C, 0x7E, 0x7B]
	currentTap = 0
	while not isRightTap(currentTap):
		currentTap += 1
	
	# Compute starting LFSR
	currentLFSR = encodedArray[0] ^ 0x20	
	
	counter = 0
	setLFSR(currentLFSR)
	setTap(currentTap)
	decodedArray = []
	while counter < len(encodedArray) and len(decodedArray) < 52:
		decodedMessage = encodedArray[counter] ^ currentLFSR
		decodedArray.append(decodedMessage)
		next()
		counter += 1
	return decodedArray
