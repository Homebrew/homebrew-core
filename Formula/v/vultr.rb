class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "404d4438f6640a34f5f287f6c9af86376ea48c72f7596a4db967dcf9eddd7f17"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1002b954c8808758fd41a2e3cb584107b65f7095e481caf7b0de2fb0536897d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "147bdca0201eb51f327006c0f2bc5af42da388aefeb442c0109ffb2c64702787"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eeb1622cbcb598e1a4a7b48ffb0a3382cd468f9ccc2f72e7d3cde442962164a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55f2aae6a6700a3fd6e10e5a2097dddd558898296349c81e10b3447d6700de97"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e38ee119810da411f025a314225c545161f6b102cf8aa52fe2a3c5df6ae978"
    sha256 cellar: :any_skip_relocation, ventura:        "728ab1a019e443585d483597d975100acc0917b9ebfe9c11758676c1b5178afc"
    sha256 cellar: :any_skip_relocation, monterey:       "48ed280f9655bdadebc57fdeecf7e6edb138f4e17c56619d0207d99c40dd5bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae78f1398416b156e5f07af807e9bc0eb994c5735fb7e7db62a32f6844b8f58"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end
