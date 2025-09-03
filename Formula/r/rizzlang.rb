class Rizzlang < Formula
  desc "Rizz++ - small GenZ-style toy language"
  homepage "https://github.com/Sriyush/RizzLang"
  if OS.mac?
    url "https://github.com/Sriyush/RizzLang/releases/download/v1.0.16/rizz-macos"
    sha256 "f76dee4dcb874fbc8ea6dab094ee60771f8c2432fa3b841631c989ba8db1f78f"
  elsif OS.linux?
    url "https://github.com/Sriyush/RizzLang/releases/download/v1.0.16/rizz-linux"
    sha256 "0042bc8eebddc4ef9578aec85e3f8cd0f30c3e69caf6c3f4a3a17431330750d0"
  end
  license "MIT"

  def install
    if OS.mac?
      bin.install "rizz-macos" => "rizz"
    elsif OS.linux?
      bin.install "rizz-linux" => "rizz"
    end
  end

  test do
    system "#{bin}/rizz", "--version"
  end
end
