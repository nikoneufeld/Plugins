/// The plugin type.  A plugin is someting that acepts an object, then modifies it, then returns it.
public typealias Plugin<Modified> = (Modified) -> Modified
public typealias Modifier<Modified> = Plugin<Modified>

/// The container which holds multiple plugins. Can apply all its plugins in  one go.
public struct PluginContainer<PluginType> {
    /// The type where the plugin will be applied
    /// All the plugins.
    public var pluginsArray = [Plugin<PluginType>]()
    /// Applies all the plugins to modified.
    /// - Parameter modified: The Object where you want to apply everything
    func applyPlugins(to modified: inout PluginType) {
        for plugin in pluginsArray {
            modified = plugin(modified)
        }
        
    }
    
    mutating func add(_ p: @escaping Plugin<PluginType>) {
        self.pluginsArray.append(p)
    }
    
}

/// A type that has plugin support
public protocol Pluginable {
    /// The only reqiurement of the protocol. A plugin container which contains all the plugins. Should be applied when neccesary
    var plugins: PluginContainer<Self> {get set}
    
}


public extension Pluginable {
    /// Applies all the plugins in it's plugin container
    mutating func applyAllPlugins() {
        plugins.applyPlugins(to: &self)
    }
}

/// Has some methods that apply plugins to it.
public protocol PluginApplieble {}
public extension PluginApplieble {
    /// Applies the plugin to its self
    /// - Parameter plugin: The plugin that you want to apply
    mutating func applyPlugin(_ plugin:  Plugin<Self>) {
        self = plugin(self)
    }
    /// Applies multiple plugins to it's self
    /// - Parameter plugins: An  varadic array of plugins. VARADIC!!
    mutating  func applyPlugins(_ plugins: Plugin<Self>...) {
        var container = PluginContainer<Self>()
        container.pluginsArray = plugins
        container.applyPlugins(to: &self)
        
    }
    /// Applies multible plugins to it's self
    /// - Parameter plugins: An array of plugins
    mutating  func applyPlugins(_ plugins: [Plugin<Self>]) {
           var container = PluginContainer<Self>()
           container.pluginsArray = plugins
           container.applyPlugins(to: &self)
           
           }

}
