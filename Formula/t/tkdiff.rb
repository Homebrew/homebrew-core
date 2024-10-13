class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.7/tkdiff-5-7.zip"
  version "5.7"
  sha256 "e2dec98e4c2f7c79a1e31290d3deaaa5915f53c8220c05728f282336bb2e405d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "15f9df18aa34124ff7f07b82a010a222f31953c5b79d2023d1a3f73912012e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29ddf811894c2d205d1e6eaa84b41a3f5797489c7c81fefb9de3a2681e6c1216"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26825675a0f738bb090488f92fc3e938f6f46f8440818f7ee1ff9c2216683c49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61c316727032802b0c7b9c9c81dba91132576818ec91e6cb113a6e52bd8dcf46"
    sha256 cellar: :any_skip_relocation, sonoma:         "0539c62c47c6be8fc69293add753b2293a60b46eb7c726eb56574b6bc004c054"
    sha256 cellar: :any_skip_relocation, ventura:        "bf357c7496e2d5a1e5b34b3aaf03295dbd99fd8e84d9b7ce0a91c64581d58738"
    sha256 cellar: :any_skip_relocation, monterey:       "6694f2dd532432dcf1db1cd9a1d9b68ddec2c8733ff22da09ad82bcae5837175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc5a64499d21648e31349090bc18855a82dea42c34cad4b72588396c0afcf24"
  end

  # upstream bug report about running with system tcl-tk, https://sourceforge.net/p/tkdiff/bugs/98/
  depends_on "tcl-tk"

  def install
    bin.install "tkdiff"
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable on GitHub Actions
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"tkdiff", "--help"
  end
end
