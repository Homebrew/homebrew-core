class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "c11ff96b6c31314f258a7a58e52e525c525452865591a581c98a37f6c0a7df60"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43a84a9f451d31c2c4805a1c021534e4f006dce1317cd565116017783e95b5e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a84a9f451d31c2c4805a1c021534e4f006dce1317cd565116017783e95b5e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a84a9f451d31c2c4805a1c021534e4f006dce1317cd565116017783e95b5e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c418ae417ad44216ba17e50996f4669504b19d32b6614aa81b8d88e5de805957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c1fba7c92b62261a59c6dc8125b916c01c657cd1092f1473f46019949e6d683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab4e14f44b07eed6933a266495d2ee2d0b688b32480b7dec04d5e907fb7f50dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", shell_parameter_format: :cobra)
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end
