class Wellington < Formula
  desc "Project-focused tool to manage Sass and spriting"
  homepage "https://getwt.io/"
  url "https://github.com/wellington/wellington/archive/v1.0.5.tar.gz"
  sha256 "e2379722849cdd8e5f094849290aacba4b789d4d65c733dec859565c728e7205"
  license "Apache-2.0"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aaeb3a098cbee88efc4e60d1edbfec242d6b2271f821b4d096fe6acb3d16987" => :catalina
    sha256 "a49538429713f2f7b979ab533d4231de84140d9e4e63b5658941552c1c99117a" => :mojave
    sha256 "53a61eeebc1e787fa7870437ce089276c5f1daad26430078e988d1b6aa50c7b8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-X github.com/wellington/wellington/version.Version=#{version}",
            "-o", bin/"wt", "wt/main.go"
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<~EOS
      /* line 1, stdin */
      div p {
        color: red; }
    EOS
    assert_equal expected, pipe_output("#{bin}/wt --comment", s, 0)
  end
end
