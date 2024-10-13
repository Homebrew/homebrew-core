class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "0672552741bd9b2e6334906c544b98fc53997e282c93265de9b332a6af7d3932"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c0546e03055b3e740dbc9ff23b35dc17cf5de8bffc33f8e873a8a998362f3dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b48228ba6da3f697f5d1c227b54afb09c2193510297628dc41f50cf953e60cc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b48228ba6da3f697f5d1c227b54afb09c2193510297628dc41f50cf953e60cc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48228ba6da3f697f5d1c227b54afb09c2193510297628dc41f50cf953e60cc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "dff5f96eda6ced21dba6c1f44edd28c514f57737a796374044604d81b2648f9d"
    sha256 cellar: :any_skip_relocation, ventura:        "dff5f96eda6ced21dba6c1f44edd28c514f57737a796374044604d81b2648f9d"
    sha256 cellar: :any_skip_relocation, monterey:       "dff5f96eda6ced21dba6c1f44edd28c514f57737a796374044604d81b2648f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4caee1bb71f9136facd421400ecc44ceba02b4249a7f01ce5a442fa752cb3bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "US/Eastern", shell_output("#{bin}/tz --list")

    assert_match version.to_s, shell_output("#{bin}/tz -v")
  end
end
