class Wellington < Formula
  desc "Project-focused tool to manage Sass and spriting"
  homepage "https://getwt.io/"
  url "https://github.com/wellington/wellington/archive/v1.0.5.tar.gz"
  sha256 "e2379722849cdd8e5f094849290aacba4b789d4d65c733dec859565c728e7205"
  license "Apache-2.0"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df25c2ccd2a972ba8e208168552d97fab66aedda36eb34df7b52b16f8db0d386" => :high_sierra
    sha256 "a0ba1b9d9b495bf840140087276b501c0458b0d9d64a7bd83d19208e5787a569" => :sierra
    sha256 "f681adb615a82377c1855000ac57c26c7403df8f8a1371646630afaddb922e63" => :el_capitan
    sha256 "224a5a7d40b14cbd89e6cec80c73fd775aaf660c94fba53d651b70aab56524e9" => :yosemite
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
