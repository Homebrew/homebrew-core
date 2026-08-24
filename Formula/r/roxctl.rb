class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.3.tar.gz"
  sha256 "a3f76e1b8be0d6dd71b0b5455155da549eba6b1334019dbcc28bfa9bc7e07d02"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbb9884db9b834a1ac74c5e0375138f1ec27642fa3c7dbc208bb94673788fc33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e84c2bd0bf162fafe0b155c61af70e3a0272607e788e766f221d9665964a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ca09a15f26ffce1bd5ede68e470ea7a67b794555cb3407b21f662c91326dcfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b41a587e027c21d93cda3284ab0bf017b35c7e0724e161c29c2ffbcfe1e7e59b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e0b389da29c8baedd7a7ce19e88ca04dadea7b3e82757ec2a1e3726eb1f26cd"
    sha256 cellar: :any,                 x86_64_linux:  "0f27bf842ca026e20227e0f9e7471dd955bba85dd7d7f71dd9f9f2078c466769"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./roxctl"

    generate_completions_from_executable(bin/"roxctl", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end
