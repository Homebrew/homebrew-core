class St2 < Formula
  desc "`st2` generate go/protobuf/thrift code from json/protobuf/thrift/go/csv code"
  homepage "https://github.com/tenfyzhong/st2"
  url "https://github.com/tenfyzhong/st2/archive/refs/tags/1.2.1.tar.gz"
  sha256 "8f0aed48964df583df96949a3fde68565d949dd92fcddd633a58105c8116e869"
  license "MIT"

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", "-ldflags", "-X 'github.com/tenfyzhong/st2/cmd/st2/config.Version=#{version}'", "-o", bin/"st2", "./cmd/st2"
    bash_completion.install "cmd/st2/autocomplete/bash_autocomplete" => "st2"
    zsh_completion.install "cmd/st2/autocomplete/zsh_autocomplete" => "st2"
    fish_completion.install "cmd/st2/completions/st2.fish" => "st2.fish"
  end

  test do
    status_output = shell_output("echo '{\"hello\": \"world\"}' | #{bin}/st2 -s json -d go")
    assert_equal "type Root struct {
\tHello string `json:\"hello,omitempty\"`
}

", status_output
  end
end
