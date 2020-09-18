class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.0.tar.gz"
  sha256 "76b96cd2ba503eef396d8773d874b4fdc56fc3aff3c61b0808afadff2a6daae7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd5a47646a5f5320d0f03ac6842199b735a46871e4e2f5c194673da075eab59e" => :catalina
    sha256 "258b9060ce582b917c2349d8ff920741d060a9a7630219fdf8579a8c5f6e398d" => :mojave
    sha256 "29167d2ad5cb6e7e42145983268467811394c949ab4e7b1dc91f2aeac131f5e9" => :high_sierra
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
