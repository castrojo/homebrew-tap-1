cask "chairlift" do
  version "1.0.0-dev"
  name "ChairLift"
  desc "System management tool for bootc-based installations"
  homepage "https://github.com/frostyard/chairlift"

  on_linux do
    arch arm: "arm64", intel: "amd64"

    sha256 arm: "b1968ce77ea792ea14733dca26a73ac135769bf946b023e9dbc81d6f46801e10",
           intel: "2f79ea682a358ae6bc4bd78259f125033f1b596fb9b143f9d94fa72a5fb61551"

    url "https://github.com/frostyard/chairlift/releases/download/dev/chairlift_#{version}_linux_#{arch}.tar.gz"

    livecheck do
      url :url
      strategy :github_latest
    end

    binary "chairlift"
    binary "data/chairlift-wrapper.sh", target: "chairlift-wrapper"
    artifact "data/org.frostyard.ChairLift.desktop",
             target: "#{Dir.home}/.local/share/applications/org.frostyard.ChairLift.desktop"
    artifact "data/icons/hicolor/scalable/apps/org.frostyard.ChairLift.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/org.frostyard.ChairLift.svg"
    artifact "data/icons/hicolor/scalable/apps/org.frostyard.ChairLift-flower.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/org.frostyard.ChairLift-flower.svg"
    artifact "data/icons/hicolor/symbolic/apps/org.frostyard.ChairLift-symbolic.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/org.frostyard.ChairLift-symbolic.svg"

    preflight do
      FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
      FileUtils.mkdir_p "#{Dir.home}/.local/share/icons/hicolor/scalable/apps"
      FileUtils.mkdir_p "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps"

      # Point the menu entry at the brew-managed wrapper so the app inherits
      # the Homebrew environment even when the session PATH lacks brew.
      desktop_file = "#{staged_path}/data/org.frostyard.ChairLift.desktop"
      content = File.read(desktop_file)
      content.gsub!(/^Exec=.*/, "Exec=#{HOMEBREW_PREFIX}/bin/chairlift-wrapper")
      File.write(desktop_file, content)
    end
  end

  # chairlift-updex-helper is intentionally not linked: it requires polkit
  # policies under /usr/share/polkit-1 that a user-scope cask cannot
  # provide. See https://github.com/frostyard/chairlift/issues/54
end
