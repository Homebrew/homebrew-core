class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.113.20.tar.gz"
  sha256 "a0d1c7d6ba1dfd796020095ec3657c6e99fb22c223e7dff12732d7b1eb07a762"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4ddd5f610f98b0eeaa6e078b910735f6f017f8679e25854d51ca28ef3bc0c44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc97b5270bf5bcadbab1d3756cb75c0ea239b783b7963987865a29ed89eca65f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf37887b7c2a529045aa5d6a3100b97cf4c29ccafb9eb5fa358b889807f6b6d6"
    sha256 cellar: :any_skip_relocation, ventura:        "62c85623ada08159ec38aa7508e9c21458963dd5016cec501373423dcf2749f5"
    sha256 cellar: :any_skip_relocation, monterey:       "ca3ccedffd60b39273a0131be56aea45931dddf8bb1e868532c58427e47b1e3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b351a6dd4d8ffa49ddc3763be48af1130cd171711dca8f4306cdc12dfc9a6d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d125e29e1aff253e50fb1e81530b6e97043a53f800f364623823ec22862676c7"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
