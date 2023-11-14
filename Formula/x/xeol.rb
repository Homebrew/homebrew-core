class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "cf74990385fdccda05469e9aa996ff88707b05a3988f5985c292f70957e9366f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a524d2effadcaa6aeee73f65249f1978835541dea30e59ecf3d1a1ba6756eaf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c44300a9dc31dbfb2260dea0b0087431e5b0d6f09e8707b828273616bd2532d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da0db8d7a6b4805d7bdc0c9c1a12db4d6c3d807502fadd2ebaf9977580bb2fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7527c1cd0641f93a093862bdd48a4e6a8ded9350c3f4ceef5ecffca60a3e6cf1"
    sha256 cellar: :any_skip_relocation, ventura:        "857ba6b427fec413252e22eaae5b0f92a0f2ea14279d320c69360ec9bfecaef3"
    sha256 cellar: :any_skip_relocation, monterey:       "a41f165e4d8235292a6f5d5abcc8a3f16f4a9c1c005fcae6c880cfbfdfcb886c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "486589204ca944db5fcc7ce9d43dbdf9ef8cc930bc301f01edcd4889387b7e34"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
