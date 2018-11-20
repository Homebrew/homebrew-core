class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v2.2.0.tar.gz"
  sha256 "cae447da53393bc7a61cf7a6411f6c9b9a9a82b4f6bb366a98dca233ef9ac42e"

  bottle do
    cellar :any_skip_relocation
    sha256 "557d258e376e83b4965afb2476815dd07b92a50c63d6794107ea45a5c3dfc368" => :mojave
    sha256 "a0aed1152f50983e9d7b254714d0f659b0db35c1c80f6385767bd311a42c5ff3" => :high_sierra
    sha256 "caf90ac3ad9d825216e32c6632e3a53fa380e41f6959b0216ffef00825e58384" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
