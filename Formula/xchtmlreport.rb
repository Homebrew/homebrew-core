class Xchtmlreport < Formula
  desc "XCTestHTMLReport: Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/TitouanVanBelle/XCTestHTMLReport"
  url "https://github.com/TitouanVanBelle/XCTestHTMLReport/archive/1.5.0.tar.gz"
  sha256 "ab8d917c867769693510de50f31d05bd6209875efe29fc1cbdfd344ce5c2ed88"
  head "https://github.com/TitouanVanBelle/XCTestHTMLReport.git"

  def install
    system "xcodebuild clean build CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO -workspace XCTestHTMLReport.xcworkspace -scheme XCTestHTMLReport -configuration Release"
    bin.install "xchtmlreport"
  end
end
