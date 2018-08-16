class Xcselect < Formula
  desc "Manage multiple versions of Xcode"
  homepage "https://github.com/pandawebsoft/xcselect"
  url "https://github.com/pandawebsoft/xcselect/archive/v1.1.0.14.tar.gz"
  sha256 "75639d12e5d91af4d4e0806518727d779bbf72b76197f44f7c08bf0cd71c4015"

  def install
    bin.install "bin/xcselect"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/xcselect --version|sed 's/[()]/./g'|rev|cut -c2-|rev").chomp
  end
end
