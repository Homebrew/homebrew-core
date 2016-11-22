class Swiftformat < Formula
  desc "A code library and command-line formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat.git",
      :tag => "0.18",
      :revision => "9d409283884b9a50ec6f6a2b8ce1c9dfb344926a"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  depends_on :xcode 

  def install
      xcodebuild "-project", 
          "SwiftFormat.xcodeproj", 
          "-scheme", "SwiftFormat (Command Line Tool)", 
          "CODE_SIGN_IDENTITY=",
          "SYMROOT=build", "OBJROOT=build" 
      bin.install "build/Release/swiftformat"
  end

  test do
      swift_code = <<-eos
      struct Potato {
          let baked: Bool
      }
      eos
      
      f = File.new("#{testpath}/potato.swift", "w")
      f.write(swift_code)
      f.close

      system "swiftformat #{testpath}/potato.swift"
  end
end
