class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.1.2.tar.gz"
  sha256 "9abd6449d3cfac6dd0658160952797502da8aceda754fbbb7c520296d82d06dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "baf1b4dde6093a5ca6d3d157ae1b260bb463da22787b64a527f4cdf6fdb01980" => :catalina
    sha256 "23e4b178904e9de67ff6ba0d794634783c38c18febdebe64e8100435db857323" => :mojave
    sha256 "ca142367b8e1d7e4214abe0fe1c66a4e684152e0641d3be1d6306d0a6395974e" => :high_sierra
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
