class Vg < Formula
  desc "Virtualgo: Easy and powerful workspace based development for go"
  homepage "https://github.com/GetStream/vg"
  url "https://github.com/GetStream/vg/archive/v0.8.0.tar.gz"
  sha256 "e7267b1306c36b3a4a4d10cb9e7ece66a9436a430bbf15028b82313496c92ebe"

  depends_on "go" => :build
  depends_on "dep" => :build
  depends_on "bindfs" => :optional

  def install
    ENV["GOPATH"] = buildpath
    vgpath = buildpath/"src/github.com/GetStream/vg"
    vgpath.install buildpath.children
    cd vgpath do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"vg",
        "-ldflags", "-w -s -X github.com/GetStream/vg/cmd.Version=#{version}"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    It is recommended to install bindfs to have the best experience
    when using full isolation and when using `vg localInstall`.

    You can install bindfs by running:
    brew cask install osxfuse
    brew install bindfs

    See https://github.com/GetStream/vg#workspace-import-modes for more.

    You can run the following command to configure all supported shells
    automatically:
    vg setup

    After this you have to reload your shell configuration file:
    source ~/.bashrc                   # for bash
    source ~/.zshrc                    # for zsh
    source ~/.config/fish/config.fish  # for fish

    You can then use `vg init` inside one of your projects to create a
    new workspace.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vg version")
  end
end
