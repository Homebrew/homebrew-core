class Taskopen < Formula
  desc "Tool for taking notes and open urls with taskwarrior"
  homepage "https://codeberg.org/jschlatow/taskopen"
  license "GPL-2.0-only"
  head "https://codeberg.org/jschlatow/taskopen.git", branch: "master"

  stable do
    # TODO: Switch to codeberg on next release. Deferred to avoid checksum change
    url "https://github.com/jschlatow/taskopen/archive/refs/tags/v2.0.3.tar.gz"
    sha256 "fe16f839279e8baff96dcead55feb03997aebdaa3cee7a421dadc8e7cb8c1581"

    # Backport replacement of PCRE as Linux distros may not provide system copy
    # and brew `pcre` is deprecated. On macOS, can still use system PCRE.
    on_linux do
      patch do
        url "https://codeberg.org/jschlatow/taskopen/commit/555e27161057b38b5d30c1d9e2b0778d66b93622.diff"
        sha256 "b0356a7fd6dc47b77b6099b4c8fc38ed7a5932a6e059a0923985f85172e716f9"
      end
      patch do
        url "https://codeberg.org/jschlatow/taskopen/commit/2e89ece66cbc9a038f50774f1a15e9e93f4d2dac.diff"
        sha256 "2b30129c16bdf43761294a9f7c93653ce973bf81665c7b470f5e9ee487b6593d"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da42ed8caf399acc74ddd682209d6673a47eed66c23172fa9856882554113de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38746ec6070116946d4d63fffceebd884df4db71e8092958d0197356ae693ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf50c36fb82f0096fba1700cf00c68f27a6da173fa49a2c09e7935c7e60ad5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "078950525ce9f618c1a98b4e552e73417ad094500be2494e4061a3c2d1474bb6"
    sha256 cellar: :any,                 arm64_linux:   "82fee5c6862258f84333118f2916ad4dee8b3ab4449f8f2f96f101486c71d260"
    sha256 cellar: :any,                 x86_64_linux:  "f1150a5b56acd30150070169ca2a96ac3f41caf9d5b2cdb39b311d02aa5202a9"
  end

  depends_on "nim" => :build
  depends_on "task"

  def install
    # Workaround for https://codeberg.org/jschlatow/taskopen/issues/180
    inreplace "taskopen.nimble", '"2.0.0alpha"', "\"#{stable.version}\""

    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    touch testpath/".taskrc"
    touch testpath/".taskopenrc"

    system "task", "add", "BrewTest"
    system "task", "1", "annotate", "Notes"

    assert_match <<~EOS, shell_output("#{bin}/taskopen diagnostics")
      Taskopen:       #{version}
        Taskwarrior:    #{Formula["task"].version}
        Configuration:  #{testpath}/.taskopenrc
    EOS
  end
end
