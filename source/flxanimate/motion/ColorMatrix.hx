package flxanimate.motion;
/**
 * Extracted from [`fl.motion.ColorMatrix`](https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/fl/motion/ColorMatrix.html)
 * 
 * ---------------------------------------------
 * The ColorMatrix class calculates and stores color matrixes based on given values. 
 * This class extends the DynamicMatrix class and also supports the ColorMatrixFilter class.
 * @see flxanimate.motion.DynamicMatrix
 * @see [flash.filters.ColorMatrixFilter](https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/filters/ColorMatrixFilter.html)
 */
class ColorMatrix extends DynamicMatrix
{
    static var lumR = 0.3086;
    static var lumG = 0.6094;
    static var lumB = 0.0820;
    /**
     * Calculates and stores color matrixes based on given values.
     * @see DynamicMatrix
     */
    public function new()
    {
        super(5, 5);
        loadIdentity();
    }
    /**
     * Calculates and stores a brightness matrix based on the given value.
     * @param value 0-255
     */
    public function setBrightnessMatrix(value:Float)
    {
        if (m_matrix == null) return;
        
        m_matrix[0][4] = value;
        m_matrix[1][4] = value;
        m_matrix[2][4] = value;
    }
    /**
     * Calculates and stores a contrast matrix based on the given value.
     * @param value 0 - 255
     */
    public function setContrastMatrix(value:Float)
    {
        if (m_matrix == null) return;

        var brightness = 0.5 * (127.0 - value);
        value /= 127;

        m_matrix[0][0] = value;
        m_matrix[1][1] = value;
        m_matrix[2][2] = value;
    
        m_matrix[0][4] = brightness;
        m_matrix[1][4] = brightness;
        m_matrix[2][4] = brightness;
    }
    /**
     * Calculates and stores a saturation matrix based on the given value.
     * @param value 0-255
     */
    public function setSaturationMatrix(value:Float)
    {
        if (m_matrix == null) return;

        var subVal = 1.0 - value;
			
        var mulVal = subVal * lumR;
        m_matrix[0][0] = mulVal + value;
        m_matrix[1][0] = mulVal;
        m_matrix[2][0] = mulVal;

        mulVal = subVal * lumG;
        m_matrix[0][1] = mulVal;
        m_matrix[1][1] = mulVal + value;
        m_matrix[2][1] = mulVal;

        mulVal = subVal * lumB;
        m_matrix[0][2] = mulVal;
        m_matrix[1][2] = mulVal;
        m_matrix[2][2] = mulVal + value;
    }
    // SVG implementation of Hue Rotation
    // See https://www.w3.org/TR/filter-effects/#feColorMatrixElement

    /*
    W3C® SOFTWARE NOTICE AND LICENSE
    http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231
    
    This work (and included software, documentation such as READMEs, or other related items) is being provided by the copyright holders under the following license. By obtaining, using and/or copying this work, you (the licensee) agree that you have read, understood, and will comply with the following terms and conditions.
    
    Permission to copy, modify, and distribute this software and its documentation, with or without modification, for any purpose and without fee or royalty is hereby granted, provided that you include the following on ALL copies of the software and documentation or portions thereof, including modifications:
    
        1. The full text of this NOTICE in a location viewable to users of the redistributed or derivative work.
        2. Any pre-existing intellectual property disclaimers, notices, or terms and conditions. If none exist, the W3C Software Short Notice should be included (hypertext is preferred, text is permitted) within the body of any redistributed or derivative code.
        3. Notice of any changes or modifications to the files, including the date changes were made. (We recommend you provide URIs to the location from which the code is derived.)
    
    THIS SOFTWARE AND DOCUMENTATION IS PROVIDED "AS IS," AND COPYRIGHT HOLDERS MAKE NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO, WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF THE SOFTWARE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD PARTY PATENTS, COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.
    
    COPYRIGHT HOLDERS WILL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF ANY USE OF THE SOFTWARE OR DOCUMENTATION.
    
    The name and trademarks of copyright holders may NOT be used in advertising or publicity pertaining to the software without specific, written prior permission. Title to copyright in this software and any associated documentation will at all times remain with copyright holders.
    */

    /**
     * Calculates and stores a hue matrix based on the given value.
     * @param value 0-255
     */
    public function setHueMatrix(angle:Float)
    {
        if (m_matrix == null) return;

        loadIdentity();

        var baseMat = new DynamicMatrix(3, 3);
        var cosBaseMat = new DynamicMatrix(3, 3);
        var sinBaseMat = new DynamicMatrix(3, 3);
        
        var cosValue = Math.cos(angle);
        var sinValue = Math.sin(angle);
        
        // slightly smaller luminance values from SVG
        var lumR = 0.213;
        var lumG = 0.715;
        var lumB = 0.072;
                
        baseMat.setValue(0, 0, lumR);
        baseMat.setValue(1, 0, lumR);
        baseMat.setValue(2, 0, lumR);
    
        baseMat.setValue(0, 1, lumG);
        baseMat.setValue(1, 1, lumG);
        baseMat.setValue(2, 1, lumG);
    
        baseMat.setValue(0, 2, lumB);
        baseMat.setValue(1, 2, lumB);
        baseMat.setValue(2, 2, lumB);
    
        cosBaseMat.setValue(0, 0, (1 - lumR));
        cosBaseMat.setValue(1, 0, -lumR);
        cosBaseMat.setValue(2, 0, -lumR);
    
        cosBaseMat.setValue(0, 1, -lumG);
        cosBaseMat.setValue(1, 1, (1 - lumG));
        cosBaseMat.setValue(2, 1, -lumG);
    
        cosBaseMat.setValue(0, 2, -lumB);
        cosBaseMat.setValue(1, 2, -lumB);
        cosBaseMat.setValue(2, 2, (1 - lumB));
    
        cosBaseMat.multiplyNumber(cosValue);
    
        sinBaseMat.setValue(0, 0, -lumR);
        sinBaseMat.setValue(1, 0, 0.143);			// not sure how this value is computed
        sinBaseMat.setValue(2, 0, -(1 - lumR));
    
        sinBaseMat.setValue(0, 1, -lumG);
        sinBaseMat.setValue(1, 1, 0.140);			// not sure how this value is computed
        sinBaseMat.setValue(2, 1, lumG);
    
        sinBaseMat.setValue(0, 2, (1 - lumB));
        sinBaseMat.setValue(1, 2, -0.283);			// not sure how this value is computed
        sinBaseMat.setValue(2, 2, lumB);
    
        sinBaseMat.multiplyNumber(sinValue);
        
        baseMat.add(cosBaseMat);
        baseMat.add(sinBaseMat);

        for (i in 0...3)
        {
            for (j in 0...3)
            {
                m_matrix[i][j] = baseMat.getValue(i, j);
            }
        }
    }

    /**
     * Calculates and returns a flat array of 20 numerical values representing the four matrixes set in this object.
     * @return An array of 20 items.
     */
    public function getFlatArray()
    {
        if (m_matrix == null) return null;

        var index = 0;
        var ptr = [];
        for (i in 0...4)
        {
            for (j in 0...5)
            {
                ptr[index] = m_matrix[i][j];

                index++;
            }
        }

        return ptr;
    }
}