class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "e82ce6217dd6650f2b63b9cc369ac4385b80d5ba7206a4301e623509ecbd46a2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "489df5c3af88a3fac2a2b35fd66ccd216b14be62f9f0cbd9b6a40c17f41f97b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489df5c3af88a3fac2a2b35fd66ccd216b14be62f9f0cbd9b6a40c17f41f97b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "489df5c3af88a3fac2a2b35fd66ccd216b14be62f9f0cbd9b6a40c17f41f97b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69d0faa834c79e843c817a23b5051edfcdf9117aebb05ebec908146433aec91"
    sha256 cellar: :any_skip_relocation, ventura:       "f69d0faa834c79e843c817a23b5051edfcdf9117aebb05ebec908146433aec91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d013a5b201b43321b17c5c75031eeb47df2191c963ef7888e4120702640a3542"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'github.com/mightymoud/sidekick/cmd.version=v#{version}'"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
