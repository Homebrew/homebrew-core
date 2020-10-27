class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.1.tar.gz"
  sha256 "73259f808d589d11ea7a18e4cd38a2e98b518a6c2c178d1ec57d9c5942277cb1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "00057268cd051af30c032b60cace608d4ce933db3d72720a04ddfa74f683086b" => :catalina
    sha256 "bf895832c539c38bdbe2958dd2f905dcf80c65fed75a3cc2778fed922b5fffe5" => :mojave
    sha256 "565f6be0a3c42a456985be592916773d394f2931b9d380692505188f9828290a" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
