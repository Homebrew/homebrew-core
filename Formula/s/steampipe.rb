class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "055ad42e472c50ab09674c0d6e37e71b526578651d775d13ecd9bf27d1ddfa6a"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adea0f39f3f1f38e3fd84589e900a2c04809898ac950703cd50b1a00a8c1509f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60e544e25d70bdb48d2a380b7f871b94c813e95b04a672668da7417406cbcca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da536f9c7bb1f6ac206158a4b23ac4962468acf5f9a7014ef0be0d2be0861a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "46818b13d085c73f8935aea5d64702526fa874c009402cc199c47c2e62dfb66e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28a7682649c94ef89e7c9b7f571b5838a6a1237a4153eb09a0f6e9d92f7a1e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff08bc2937aa8fe5a6bcb77bd2ab3cec8adb36a029d07733e015534dd502d7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end
