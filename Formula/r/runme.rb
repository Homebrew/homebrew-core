class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "572545279edd74c1b5a72d57e1e9767d6484d27e864101b6d7f20d9a3a494aaf"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97bdb1c9f46b4402a469c4aad522f1616d40bc925d4e5ac28169aad61147ae33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef069ace9c9e20ae2f22106508597d4430d7dfc78ad11d4bb6a17a44957df25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d3b0f16b18e75b4a6183a626bc5b94ecc83b56db45b1b2c3813e7d2f20e827"
    sha256 cellar: :any_skip_relocation, sonoma:         "22db29a95070ce0d985a0f6462ee9a395c559e3b6701c1e6cb2c55b36c48afb1"
    sha256 cellar: :any_skip_relocation, ventura:        "fc9e5c07754527eb6acdc15910055033f9d0060aba9f9f63aef066cd2408006f"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b3e96ae6a796dfea9e4ac2932446ee432b929957c4c468b756007d56c00d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364d4d877109d3b8822ba75f5337fe65508de7aa05258220544138ba20bbcc86"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
