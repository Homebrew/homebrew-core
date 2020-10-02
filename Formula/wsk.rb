class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.1.0.tar.gz"
  sha256 "d2365117b7c9144ed088b0d6a08c789df1e532e212223dc550d78ce2e1a92ae4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "461c8bd630f1fb80859d16f1ef4ec57ba73990febdada45deb0411b66fca044e" => :catalina
    sha256 "3082ab49e515fa5b534ee3e8f0de9e90a23d7130d9fbf5f469ea5ef3f40c8bd9" => :mojave
    sha256 "9ea3a295b2eb7b4f622ec8d6065aa5a9cd50285d83df66453e41d2214de6135c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go-bindata", "-pkg", "wski18n", "-o",
                          "wski18n/i18n_resources.go", "wski18n/resources"

    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
