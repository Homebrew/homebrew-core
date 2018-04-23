class Xchtmlreport < Formula
  desc "XCTestHTMLReport: Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/TitouanVanBelle/XCTestHTMLReport"
  url "https://github.com/TitouanVanBelle/XCTestHTMLReport/archive/1.7.0.tar.gz"
  sha256 "85ac4fd6110e9919006e3ae8a66e6ff31917495312435d0faa49d4325cbb1170"
  head "https://github.com/TitouanVanBelle/XCTestHTMLReport.git", :branch => "develop"

  def install
    system "xcodebuild clean build CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO -workspace XCTestHTMLReport.xcworkspace -scheme XCTestHTMLReport -configuration Release"
    bin.install "xchtmlreport"
  end
end
