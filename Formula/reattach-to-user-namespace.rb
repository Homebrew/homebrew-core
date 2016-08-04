class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.5.tar.gz"
  sha256 "26f87979a4a2cf81ca4ff9e1e097e7132babf2ff2ef5eb03ebfc3b510345a147"

  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "901c639c93b3f51d67891e748eed78604aceb6fec62812418e40fec009a731ab" => :el_capitan
    sha256 "1b7853288694d4ea8bff21141de050b1fa5be5920583ce4a472ac02653e6490a" => :yosemite
    sha256 "992f682ed9778b151164ade1a0fc67b85ce1368094c962857e0acbd408f6ace6" => :mavericks
  end

  option "with-wrap-pbcopy-and-pbpaste", "Include wrappers for pbcopy/pbpaste that shim in this fix"
  option "with-wrap-launchctl", "Include wrapper for launchctl with this fix"
  deprecated_option "wrap-pbcopy-and-pbpaste" => "with-wrap-pbcopy-and-pbpaste"
  deprecated_option "wrap-launchctl" => "with-wrap-launchctl"

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
    wrap_pbpasteboard_commands if build.with? "wrap-pbcopy-and-pbpaste"
    wrap_launchctl if build.with? "wrap-launchctl"
  end

  def wrap_pbpasteboard_commands
    make_executable_with_content("pbcopy", "cat - | reattach-to-user-namespace /usr/bin/pbcopy")
    make_executable_with_content("pbpaste", "reattach-to-user-namespace /usr/bin/pbpaste")
  end

  def wrap_launchctl
    make_executable_with_content("launchctl", 'reattach-to-user-namespace /bin/launchctl "$@"')
  end

  def make_executable_with_content(executable_name, content_lines)
    executable = bin.join(executable_name)
    content = [*content_lines].unshift("#!/bin/sh").join("\n")
    executable.write(content)
    executable.chmod(0755)
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
