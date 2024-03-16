class Qurancli < Formula
  desc "Simple tool to Read, Search and Recite the Quran"
  homepage "https://github.com/ahmedsaheed/quranCLI"
  url "https://github.com/ahmedsaheed/quranCLI/releases/download/v1.0.0/qurancli-1.0.zip"
  version "1.0.0"
  sha256 "572b1d3073e318876a95e1fa38cd539cae8490336a6c6f4c9ce20f6887cbc042"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/qurancli" => "qurancli"
  end

  test do
    output = shell_output("#{bin}/qurancli --version")
    assert_match "1.0", output
  end
end
