class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.2.1.tar.gz"
  sha256 "91aad8002532f6dc236fb6edf3a200e37fb1efc038a880606fe96927e3a64fc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9448e0dd427f0454b1d8a5eb13f085e4a26dbc2c08ae65e241540dd2953aa534" => :catalina
    sha256 "786799b833eca9c2ec295436898e6feaa624fa0df2210a1cb6282e3f8dc68eed" => :mojave
    sha256 "79e426d94d0a09a10c46c893cfceef01b1e4df7b86780f632a5302d0d393b5cf" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

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
