class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.0.0.tar.gz"
  sha256 "31e6fceaa3ae51be7b93d308eb0b68c891277f904c17cf6496e51062f1655332"

  bottle do
    cellar :any_skip_relocation
    sha256 "461c8bd630f1fb80859d16f1ef4ec57ba73990febdada45deb0411b66fca044e" => :catalina
    sha256 "3082ab49e515fa5b534ee3e8f0de9e90a23d7130d9fbf5f469ea5ef3f40c8bd9" => :mojave
    sha256 "9ea3a295b2eb7b4f622ec8d6065aa5a9cd50285d83df66453e41d2214de6135c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/apache/openwhisk-cli"
    dir.install buildpath.children
    cd dir do
      system "go-bindata", "-pkg", "wski18n", "-o",
                           "wski18n/i18n_resources.go", "wski18n/resources"
      system "govendor", "sync"

      system "go", "build", "-o", bin/"wsk"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
