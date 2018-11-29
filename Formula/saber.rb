class Saber < Formula
  desc "DI & IoC command-line tool for Swift based on code generation"
  homepage "https://github.com/apleshkov/saber"
  url "https://github.com/apleshkov/saber.git",
      :tag => "0.1.2"
  sha256 "5f78a013e5ecaba2331f7653de48a80444c178febde1647295b2995e56eedf55"
  depends_on :xcode => ["10.0", :build]

  # --disable-sandbox b/c of https://github.com/Homebrew/homebrew-core/pull/18456

  def install
    system [
      "make",
      "install",
      "SWIFT_BUILD_XFLAGS=--disable-sandbox",
      "PREFIX=#{prefix}",
      "TEMP_FOLDER=#{buildpath}/Saber.dst",
    ].join(" ")
  end

  test do
    # Saber is based on SourceKitten, so
    # see https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/saber", "version"
  end
end
