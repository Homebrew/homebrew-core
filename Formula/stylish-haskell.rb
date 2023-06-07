class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.4.0.tar.gz"
  sha256 "7858b2e5089fb6845d5fa2a92f69626c7275ead7e44ec8c8308f73d1a288fed6"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51d1df764956a621c476236c7ded7ea9477e13d20a6a8a8f107375c0f2d151b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e69da5d7320067b6d857987c950df3d4349e7bd67f732a787a922a15bd7074a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdc3ad742d0a2c3902529e9bc6296249a17ffb324050f7938b5c5522fb593587"
    sha256 cellar: :any_skip_relocation, ventura:        "7d05f8709b71519045f85ac9908f51cbb92c61832c1b00dd938ca54dcd430978"
    sha256 cellar: :any_skip_relocation, monterey:       "83e57499cd7466fcc708497a0f6de97aed56c19edc84813a8d7750700bf5f375"
    sha256 cellar: :any_skip_relocation, big_sur:        "161ca04c28e5c435286a75f6a1f21a37c78d7c1b2fb48beaef9afe0fa1956e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64cf38932ef91fa6346077bd6751fea32779ec45a9cc279cab380e3e38bab02"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    # Work around build failure by enabling `ghc-lib` flag
    # lib/Language/Haskell/Stylish/GHC.hs:71:51: error:
    #     • Couldn't match expected type 'GHC.LlvmConfig'
    #                   with actual type 'ghc-lib-parser-9.4.3.20221104:GHC.Driver.Session.LlvmConfig'
    # Issue ref: https://github.com/haskell/stylish-haskell/issues/405
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+ghc-lib"
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
