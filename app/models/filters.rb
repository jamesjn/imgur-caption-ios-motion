class Filters
  def self.filterImageHue image
    filteredImage = CIImage.alloc.initWithCGImage(image.CGImage, options:nil)
    filter = CIFilter.filterWithName("CIHueAdjust")
    filter.setDefaults()
    filter.setValue(filteredImage, forKey:"inputImage")
    filter.setValue(NSNumber.numberWithFloat(3.0), forKey:"inputAngle")
    outputImage = filter.valueForKey("outputImage")
    
    context = CIContext.contextWithOptions(nil)

    imgRef = context.createCGImage(outputImage, fromRect:(outputImage.extent))
    originalOrientation = image.imageOrientation
    UIImage.alloc.initWithCGImage(imgRef, scale:1.0, orientation:originalOrientation)
  end

  def self.filterImageGamma image
    filteredImage = CIImage.alloc.initWithCGImage(image.CGImage, options:nil)
    filter = CIFilter.filterWithName("CIGammaAdjust")
    filter.setDefaults()
    filter.setValue(filteredImage, forKey:"inputImage")
    filter.setValue(NSNumber.numberWithFloat(2.0), forKey:"inputPower")
    outputImage = filter.valueForKey("outputImage")
    
    context = CIContext.contextWithOptions(nil)

    imgRef = context.createCGImage(outputImage, fromRect:(outputImage.extent))
    originalOrientation = image.imageOrientation
    UIImage.alloc.initWithCGImage(imgRef, scale:1.0, orientation:originalOrientation)
  end

  def self.filterImageColor image
    filteredImage = CIImage.alloc.initWithCGImage(image.CGImage, options:nil)
    filter = CIFilter.filterWithName("CIColorControls")
    filter.setDefaults()
    filter.setValue(filteredImage, forKey:"inputImage")
    filter.setValue(NSNumber.numberWithFloat(2.0), forKey:"inputSaturation")
    filter.setValue(NSNumber.numberWithFloat(1.0), forKey:"inputBrightness")
    filter.setValue(NSNumber.numberWithFloat(2.0), forKey:"inputContrast")
    outputImage = filter.valueForKey("outputImage")
    
    context = CIContext.contextWithOptions(nil)

    imgRef = context.createCGImage(outputImage, fromRect:(outputImage.extent))
    originalOrientation = image.imageOrientation
    UIImage.alloc.initWithCGImage(imgRef, scale:1.0, orientation:originalOrientation)
  end

  def self.filterImageInvert image
    filteredImage = CIImage.alloc.initWithCGImage(image.CGImage, options:nil)
    filter = CIFilter.filterWithName("CIColorInvert")
    filter.setDefaults()
    filter.setValue(filteredImage, forKey:"inputImage")
    outputImage = filter.valueForKey("outputImage")

    context = CIContext.contextWithOptions(nil)

    imgRef = context.createCGImage(outputImage, fromRect:(outputImage.extent))
    originalOrientation = image.imageOrientation
    UIImage.alloc.initWithCGImage(imgRef, scale:1.0, orientation:originalOrientation)
  end

  def self.filterImageSephia image
    filteredImage = CIImage.alloc.initWithCGImage(image.CGImage, options:nil)
    filter = CIFilter.filterWithName("CISepiaTone")
    filter.setDefaults()
    filter.setValue(filteredImage, forKey:"inputImage")
    filter.setValue(NSNumber.numberWithFloat(1.0), forKey:"inputIntensity")
    outputImage = filter.valueForKey("outputImage")

    context = CIContext.contextWithOptions(nil)

    imgRef = context.createCGImage(outputImage, fromRect:(outputImage.extent))
    originalOrientation = image.imageOrientation
    UIImage.alloc.initWithCGImage(imgRef, scale:1.0, orientation:originalOrientation)
  end
end
