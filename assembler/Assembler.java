package assembler;
import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.Scanner; 
import java.util.HashMap;
import java.util.*;

public class Assembler {

	public static void main(String[] args) {
		
		HashMap<String, String> regNums = new HashMap<>();
		HashMap<String, String> opNums = new HashMap<>();
		HashMap<String, String> intNums = new HashMap<>();
		HashMap<String, Integer> loopNums = new HashMap<>();
		
		opNums.put("lsa", "000");
		opNums.put("lrm", "001");
		opNums.put("snxa", "010");
		opNums.put("bor", "011");
		opNums.put("rxor", "100");
		opNums.put("set", "110000");
		opNums.put("DONE", "111000000");
		
		regNums.put("r0", "000");
		regNums.put("r1", "001");
		regNums.put("r2", "010");
		regNums.put("r3", "011");
		regNums.put("r4", "100");
		regNums.put("r5", "101");
		regNums.put("r6", "110");
		regNums.put("r7", "111");
		
		intNums.put("#0", "000");
		intNums.put("#1", "001");
		intNums.put("#2", "010");
		intNums.put("#3", "011");
		intNums.put("#4", "100");
		intNums.put("#5", "101");
		intNums.put("#6", "110");
		intNums.put("#7", "111");
		
		int count = 0;
		int cins = 0;
		try {
		File prog0 = new File ("C:/Users/danic/eclipse-workspace/assembler/assembler/program1.txt");
		Scanner myReader0 = new Scanner(prog0);
		while(myReader0.hasNextLine()) {
			String data = myReader0.nextLine();
			data = data.replaceAll(",","");
			data = data.replaceAll(":","");
			String[] splited = data.split("\\s+");
			
			if (splited.length == 1 && (!opNums.containsKey(splited[0]))) {
				loopNums.put(splited[0], count-cins);
				cins++;
			}
			count++;
			
		}
		myReader0.close();
		} catch (FileNotFoundException e) {
		System.out.println("cant read file");
		}
		
		int flag = 0;
		boolean newline = true;
		count = 0;
		cins = 0;
		try {
		File prog1 = new File ("C:/Users/danic/eclipse-workspace/assembler/assembler/program1.txt");
		Scanner myReader = new Scanner(prog1);
		while(myReader.hasNextLine()) {
			if(count != 0 && newline) {
			System.out.println("");
			}
			String data = myReader.nextLine();
			data = data.replaceAll(",","");
			data = data.replaceAll(":","");
			String[] splited = data.split("\\s+");
			
			for (int i = 0; i<splited.length;i++) {
				if (loopNums.containsKey(splited[i]) && (splited.length != 1)) {
					
					int a = loopNums.get(splited[i]) - count;
					//System.out.println("BRANCH "+a);
					String result = Integer.toBinaryString(a);
					for(int k = result.length(); k<32;k++) {
						result = "0"+result;
					}
					String resultWithPadding = result.substring(26, 32);
					System.out.print(resultWithPadding);
					newline = true;
					
				}
				else if (loopNums.containsKey(splited[i]) && (splited.length == 1)) {
					count--;
					newline = false;
					
				}
				else if (splited.length == 2 && (i==1) && opNums.containsKey(splited[0]) &&regNums.containsKey(splited[1])) {
					System.out.print("000" + regNums.get(splited[i]));
					newline = true;
				}
				
				else if(regNums.containsKey(splited[i])) {
					System.out.print(regNums.get(splited[i]));
					newline = true;
				}
				
				else if (opNums.containsKey(splited[i])) {
					System.out.print(opNums.get(splited[i]));
					newline = true;
					
				}
				else if (intNums.containsKey(splited[i])) {
					
					System.out.print(intNums.get(splited[i]));
					newline = true;
					
				}
				else {
					newline = false;
				}
				
			}
			count ++;
			
			
			
		}
		myReader.close();
		} catch (FileNotFoundException e) {
			System.out.println("cant read file");
		}

	}

}
