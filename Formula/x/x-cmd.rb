class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://raw.githubusercontent.com/x-cmd/release/main/dist/v0.5.5/allinone.tgz"
  sha256 "362928f94aa56ae5ccd9c651584c35c1207097b730745eba5c6cba0d7fcf1d45"
  license "AGPL-3.0-only"

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  def install
    (prefix/"").install Dir.glob("*", File::FNM_DOTMATCH) - %w[. ..]
    (prefix/"bin").mkpath
    cp prefix/"mod/x-cmd/lib/bin/x-cmd", prefix/"bin/x-cmd"
    replace_path_in_file(prefix/"bin/x-cmd")
  end

  def replace_path_in_file(file)
    if File.read(file).include?("/opt/homebrew/Cellar/x-cmd/latest")
      inreplace file, "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    end
  end

  test do
    assert_match(/tag:\s*v#{Regexp.escape(version)}/, shell_output("#{bin}/x-cmd version"))
  end
end
