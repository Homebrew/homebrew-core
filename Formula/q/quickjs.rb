class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2024-01-13.tar.xz"
  sha256 "3c4bf8f895bfa54beb486c8d1218112771ecfc5ac3be1036851ef41568212e03"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "9ac6a1c14a372f8e110aa703ccace27e88126187cb3af83c8182dfdad70dc0df"
    sha256 arm64_sonoma:   "d8e22767ae91c9911e9c4d2dcac7af64721903c7c90cb90a4ff5218b14c9e403"
    sha256 arm64_ventura:  "7470c608a6769f8269a9a66644291809ab3f453a974736973487a0e3abbbdee6"
    sha256 arm64_monterey: "0f7cbd908a98955c57b6ab1cd86614c560c98992107c9a0c4a565bec96e77168"
    sha256 sonoma:         "4b4183ec2ae090f33781c4ca33446ae5597910c3bbc6ad23dab6197c1396b35c"
    sha256 ventura:        "5f0d78ed0a0ce5e317996918f860783f4744573ef601b56ae3df0346730b5ab3"
    sha256 monterey:       "6f93efa66e963ddc9f2eae93713aed75373a7b7d62ceaeba9c57da6c98969cf8"
    sha256 x86_64_linux:   "34e76af7014843804104d0885e72d6c9adc203cb54bfabff61577230e4498c9e"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match(/^QJS42/, output)

    test_file = testpath/"test.js"
    test_file.write "console.log('hello');"
    system bin/"qjsc", test_file
    assert_equal "hello", shell_output(testpath/"a.out").strip
  end
end
