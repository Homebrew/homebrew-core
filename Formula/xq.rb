class Xq < Formula
  desc "Command-line XML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "9ab6d0fd2ef3e1ca6c74fec8a466c20d65fd5330eaf75d16a22bf878c5500493"
  license "MIT"
  head "https://github.com/sibprogrammer/xq.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
