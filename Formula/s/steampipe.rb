class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "d91ae2dcbacd001903feb92bfc89b5efbe8c9ec284be8a32eb2e3cf674a7e562"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89f360d60337cf32f38c7d5b831051841e47d8da7602a3865cb6197526d8bef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58913f9abf06455201cff8e0ffc0d554be49da1d21ca972e85a440cce1224272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e109ebb86cbbe5ed4992565a4041ca04a96e27562ba6f02b07af73e22f09d72"
    sha256 cellar: :any_skip_relocation, sonoma:         "26bf818ce37443030e7dd572a27f21c0afed5738dff70a29892d6bae30f82a17"
    sha256 cellar: :any_skip_relocation, ventura:        "818d1d0f99397f91e602063c8deeb75a419149635fed7e5e30404f582c4af61e"
    sha256 cellar: :any_skip_relocation, monterey:       "a3144397cf03c959e1279c7f3088fcae546d935f13f925d7c2049e513a6de2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d844879e3a307c3c7f4ce4611eb04fa099d5f4b3d97d5b9366721852a9b149b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
