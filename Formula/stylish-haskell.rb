class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.2.0.tar.gz"
  sha256 "e70081f863a406f0f048799d9fb2e6d92ad486bf9d5364609902155bfd2c3ea8"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8492583c2c98984f12b0aaa8a49bc40778236e939a19359e1e9b17d2c949cd04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f938218d664df786dbabfff415d3d3849ff7dfb31fe0224ef07240f96c9213f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0bc56f858f8f60acc7b78abac39c075985ab5caecf5d8cefdc8826c360dbc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "29d61a1b5bd338b7e9ae143afc2512140ed1f67db8ff8b6aa0a59680cb08d336"
    sha256 cellar: :any_skip_relocation, catalina:       "e9bbb68478ac1ec25e17b2b27f552120a744aa59fd4c30fdcc9bcbcfb3aab595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "662314c0c7f3388ff069c5a31fed485c5a93ff54b2f4c84ba680686509c2772c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    EOS
    expected = <<~EOS
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    EOS
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
