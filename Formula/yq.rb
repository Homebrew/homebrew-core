class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.0.tar.gz"
  sha256 "76b96cd2ba503eef396d8773d874b4fdc56fc3aff3c61b0808afadff2a6daae7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4679c723a46faa9921951239e5ec7d97570c42e521eefd772c2dcb6999187b9" => :catalina
    sha256 "c5d57a09d20dac8753fd41f1738e80594684e6a714d210483ba9f8d687ad0344" => :mojave
    sha256 "b88ba305a70f8054611de1bdab8954c9864b456374e70d499bc1241895e3ee4d" => :high_sierra
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
