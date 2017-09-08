package controller;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Utils {
	public static String hashMD5Password(String plainPassword)
	{
		String hashedPassword = "";
		try
		{
			MessageDigest m = MessageDigest.getInstance("MD5");
			m.reset();
			m.update(plainPassword.getBytes());
			byte[] digest = m.digest();
			BigInteger bigInt = new BigInteger(1,digest);
			hashedPassword = bigInt.toString(16);
		} catch (NoSuchAlgorithmException ex)
		{
			
		}
		return hashedPassword;
	}
}
