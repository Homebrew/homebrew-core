class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.7/tkdiff-5-7.zip"
  version "5.7"
  sha256 "e2dec98e4c2f7c79a1e31290d3deaaa5915f53c8220c05728f282336bb2e405d"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9df1848b67170c556bedec9313ed342304d7170d544c98840847dd2a7517bcf"
  end

  # upstream bug report about running with system tcl-tk, https://sourceforge.net/p/tkdiff/bugs/98/
  depends_on "tcl-tk@8"

  def install
    bin.install "tkdiff"
    bin.env_script_all_files libexec, PATH: "#{Formula["tcl-tk@8"].opt_bin}:${PATH}"
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable on GitHub Actions
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"tkdiff", "--help"
  end
end
