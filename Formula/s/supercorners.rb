cask "supercorners" do
  version "1.2.0"
  sha256 "272bbd46754497813f3eeb905ef3d257dee033f6d53098b4d1ceab9b9b8bab1c"

  url "https://github.com/daniyalmaster693/SuperCorners/releases/download/#{version}/SuperCorners.zip"
  name "SuperCorners"
  desc "Make Your Mac's Corners Useful Again"
  homepage "https://github.com/daniyalmaster693/SuperCorners"

  livecheck do
    url "https://daniyalmaster693.github.io/SuperCorners/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "SuperCorners.app"

uninstall quit: "daniyalmaster.SuperCorners"

zap trash: [
  "~/Library/Application Scripts/daniyalmaster.SuperCorners",
  "~/Library/Application Support/SuperCorners",
  "~/Library/Caches/daniyalmaster.SuperCorners",
  "~/Library/HTTPStorages/daniyalmaster.SuperCorners",
  "~/Library/Preferences/daniyalmaster.SuperCorners.plist",
]
end