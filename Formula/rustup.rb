class Rustup < Formula
  TOOLS = %w[rustup rustc rustdoc cargo rust-lldb rust-gdb].freeze

  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  # Use the tag instead of the tarball to get submodules
  url "https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init", :using => :nounzip
  version "1.0.0"
  sha256 "2da68a13feb9a691ef3b59d0d6d53af617962ab5ba4673eaf3818778ccd00bec"

  conflicts_with "multirust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"
  conflicts_with "rust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  def install
    TOOLS.each do |tool|
      cp "rustup-init", tool
      bin.install tool
      (bin/tool).chmod 0555
    end

    (bash_completion/"rustup").write `#{bin/"rustup"} completions bash`
    (zsh_completion/"_rustup").write `#{bin/"rustup"} completions zsh`
    (fish_completion/"rustup.fish").write `#{bin/"rustup"} completions fish`
  end

  def caveats; <<-EOS.undent
    Rustup stores data under ~/.rustup and ~/.cargo by default. If you
    absolutely need to store everything under Homebrew's prefix, include this in
    your profile:
      export RUSTUP_HOME=#{var}/rustup
      export CARGO_HOME=#{var}/cargo
    EOS
  end

  test do
    assert_equal "rustup 1.0.0 (17b6d21 2016-12-15)",
                 shell_output("#{bin/"rustup"} -V").strip
  end
end
