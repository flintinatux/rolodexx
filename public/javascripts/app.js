(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';

    if (has(cache, path)) return cache[path].exports;
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex].exports;
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
require.register("application", function(exports, require, module) {
var Application;

Application = {
  initialize: function() {
    require('lib/protect_from_csrf');
    require('views/main');
    return require('router');
  }
};

module.exports = Application;
});

;require.register("collections/contacts", function(exports, require, module) {
var Contacts,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Contacts = (function(_super) {
  __extends(Contacts, _super);

  function Contacts() {
    return Contacts.__super__.constructor.apply(this, arguments);
  }

  Contacts.prototype.url = '/contacts';

  Contacts.prototype.model = require('models/contact');

  return Contacts;

})(Backbone.Collection);

module.exports = new Contacts();
});

;require.register("initialize", function(exports, require, module) {
var application;

application = require('application');

$(document).ready(function() {
  application.initialize();
  return Backbone.history.start({
    pushState: false
  });
});
});

;require.register("lib/composite_view", function(exports, require, module) {
var CompositeView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CompositeView = (function(_super) {
  __extends(CompositeView, _super);

  function CompositeView() {
    return CompositeView.__super__.constructor.apply(this, arguments);
  }

  CompositeView.prototype.initialize = function(options) {
    CompositeView.__super__.initialize.call(this, options);
    return this.children = _([]);
  };

  CompositeView.prototype.renderChild = function(child) {
    this.children.push(child);
    child.parent = this;
    return child.render();
  };

  CompositeView.prototype.remove = function() {
    this.trigger('remove');
    CompositeView.__super__.remove.call(this);
    this._removeChildren();
    this._removeFromParent();
    return this;
  };

  CompositeView.prototype.swapped = function() {
    this.trigger('swapped');
    return this;
  };

  CompositeView.prototype._removeChild = function(child) {
    var index;
    index = this.children.indexOf(child);
    return this.children.splice(index, 1);
  };

  CompositeView.prototype._removeChildren = function() {
    return _.each(this.children.clone(), function(child) {
      return child.remove();
    });
  };

  CompositeView.prototype._removeFromParent = function() {
    if (this.parent) {
      return this.parent._removeChild(this);
    }
  };

  return CompositeView;

})(Backbone.View);

module.exports = CompositeView;
});

;require.register("lib/protect_from_csrf", function(exports, require, module) {
var session;

session = require('session');

Backbone._sync = Backbone.sync;

Backbone.sync = function(method, model, options) {
  var beforeSend;
  beforeSend = options.beforeSend;
  options.beforeSend = function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', session.get('csrf_token'));
    if (beforeSend) {
      return beforeSend.apply(this, arguments);
    }
  };
  return Backbone._sync(method, model, options);
};
});

;require.register("lib/swapping_router", function(exports, require, module) {
var SwappingRouter,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SwappingRouter = (function(_super) {
  __extends(SwappingRouter, _super);

  function SwappingRouter() {
    return SwappingRouter.__super__.constructor.apply(this, arguments);
  }

  SwappingRouter.prototype.execute = function(callback, args) {
    this.params = this._parseParams(args.pop());
    return callback != null ? callback.apply(this, args) : void 0;
  };

  SwappingRouter.prototype.navigate = function(fragment, options) {
    var url;
    if (options == null) {
      options = {};
    }
    url = new URI(fragment.replace('#', ''));
    if (options.params != null) {
      url.query(options.params);
    }
    return SwappingRouter.__super__.navigate.call(this, "#" + (url.toString()), _.omit(options, 'params'));
  };

  SwappingRouter.prototype.swap = function(newView) {
    var _ref;
    if ((_ref = this.currentView) != null) {
      _ref.remove();
    }
    this.currentView = newView;
    this.$el.html(this.currentView.render().el);
    this.currentView.swapped();
    return this;
  };

  SwappingRouter.prototype._parseParams = function(params) {
    if (!params) {
      return {};
    }
    return new URI("?" + params).query(true);
  };

  return SwappingRouter;

})(Backbone.Router);

module.exports = SwappingRouter;
});

;require.register("models/address", function(exports, require, module) {
var Address,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Address = (function(_super) {
  __extends(Address, _super);

  function Address() {
    return Address.__super__.constructor.apply(this, arguments);
  }

  return Address;

})(Backbone.NestedAttributesModel);

module.exports = Address;
});

;require.register("models/contact", function(exports, require, module) {
var Address, Contact,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Address = require('models/address');

Contact = (function(_super) {
  __extends(Contact, _super);

  function Contact() {
    return Contact.__super__.constructor.apply(this, arguments);
  }

  Contact.prototype.urlRoot = '/contacts';

  Contact.prototype.relations = [
    {
      type: 'one',
      key: 'address',
      relatedModel: function() {
        return Address;
      }
    }
  ];

  Contact.prototype.choose = function() {
    this.collection.each(function(contact) {
      return contact.set({
        active: false
      });
    });
    return this.set({
      active: true
    });
  };

  return Contact;

})(Backbone.NestedAttributesModel);

module.exports = Contact;
});

;require.register("router", function(exports, require, module) {
var Contact, ContactView, Router, SwappingRouter, contacts,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Contact = require('models/contact');

ContactView = require('views/contact');

SwappingRouter = require('lib/swapping_router');

contacts = require('collections/contacts');

Router = (function(_super) {
  __extends(Router, _super);

  function Router() {
    return Router.__super__.constructor.apply(this, arguments);
  }

  Router.prototype.execute = function(callback, args) {
    this.$el = $('#contact_wrapper');
    if (contacts.isEmpty()) {
      return contacts.fetch({
        success: (function(_this) {
          return function() {
            return Router.__super__.execute.call(_this, callback, args);
          };
        })(this)
      });
    } else {
      return Router.__super__.execute.call(this, callback, args);
    }
  };

  Router.prototype.routes = {
    '': 'home',
    'contacts': 'first',
    'contacts/new': 'new_contact',
    'contacts/:id': 'show',
    'contacts/:id/edit': 'edit'
  };

  Router.prototype.edit = function(id) {};

  Router.prototype.first = function() {
    return this._show(contacts.first());
  };

  Router.prototype.home = function() {
    return this.navigate('#/contacts', {
      trigger: true,
      params: this.params
    });
  };

  Router.prototype.new_contact = function() {};

  Router.prototype.show = function(id) {
    return this._show(contacts.get(id));
  };

  Router.prototype._show = function(model) {
    model.choose();
    return this.swap(new ContactView({
      model: model,
      params: this.params
    }));
  };

  return Router;

})(SwappingRouter);

module.exports = new Router();
});

;require.register("session", function(exports, require, module) {
var Session, session,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Session = (function(_super) {
  __extends(Session, _super);

  function Session() {
    return Session.__super__.constructor.apply(this, arguments);
  }

  Session.prototype.url = '/session';

  return Session;

})(Backbone.Model);

session = new Session();

session.fetch();

module.exports = session;
});

;require.register("templates/card", function(exports, require, module) {
var __templateData = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

buf.push("<span id=\"arrow\"><i class=\"fa fa-chevron-right\"></i></span><img id=\"avatar\" width=\"32\" height=\"32\"/><span id=\"name\"></span>");;return buf.join("");
};
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/contact", function(exports, require, module) {
var __templateData = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

buf.push("<div class=\"page-header\"><h1><span id=\"name\"></span><span id=\"edit\" data-toggle=\"tooltip\" title=\"Edit contact\"><i class=\"fa fa-pencil\"></i></span></h1></div><div class=\"row\"><div class=\"col-xs-4\"><img id=\"avatar\" width=\"256\" height=\"256\"/></div><div class=\"col-xs-8\"><div class=\"row\"><div class=\"col-xs-4\"><p class=\"contact-label\">Sex</p><p id=\"sex\"></p></div><div class=\"col-xs-4\"><p class=\"contact-label\">Age</p><p id=\"age\"></p></div><div class=\"col-xs-4\"><p class=\"contact-label\">Birthday</p><p id=\"birthday\"></p></div></div><div class=\"row\"><div class=\"col-xs-12\"><p class=\"contact-label\">Address</p><p><span id=\"street\"></span><br/><span id=\"city\"></span>,&nbsp;<span id=\"state\"></span>&nbsp;&nbsp;<span id=\"postcode\"></span></p></div></div><div class=\"row\"><div class=\"col-xs-4\"><p class=\"contact-label\">Phone</p><p id=\"phone\"></p></div><div class=\"col-xs-8\"><p class=\"contact-label\">Email</p><p id=\"email\"></p></div></div></div></div>");;return buf.join("");
};
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/contacts", function(exports, require, module) {
var __templateData = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

buf.push("<div id=\"new_contact_wrapper\"><button id=\"new\" class=\"btn btn-success btn-block\"><i class=\"fa fa-plus\"></i> Create new contact</button></div>");;return buf.join("");
};
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/main", function(exports, require, module) {
var __templateData = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

buf.push("<nav class=\"navbar navbar-default navbar-static-top\"><div class=\"container-fluid\"><div class=\"navbar-header\"><a href=\"/\" class=\"navbar-brand\"><i class=\"fa fa-sort-alpha-asc\"></i> The Rolodexx</a></div><p class=\"navbar-text navbar-right\">The way your grandma used to remember things.</p></div></nav><div id=\"content\" class=\"container-fluid\"><div class=\"row\"><div id=\"contacts\" class=\"col-xs-3\"></div><div id=\"contact_wrapper\" class=\"col-xs-9\"></div></div></div>");;return buf.join("");
};
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/card", function(exports, require, module) {
var Card, CompositeView, router,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CompositeView = require('lib/composite_view');

router = require('router');

Card = (function(_super) {
  __extends(Card, _super);

  function Card() {
    return Card.__super__.constructor.apply(this, arguments);
  }

  Card.prototype.template = require('templates/card');

  Card.prototype.className = 'card';

  Card.prototype.bindings = {
    ':el': {
      attributes: [
        {
          name: 'class',
          observe: 'active',
          onGet: function(val) {
            if (val) {
              return 'active';
            } else {
              return '';
            }
          }
        }
      ]
    },
    '#avatar': {
      attributes: [
        {
          name: 'src',
          observe: 'gravatar_hash',
          onGet: function(val) {
            return "http://www.gravatar.com/avatar/" + val + "?d=mm&s=32";
          }
        }
      ]
    },
    '#name': 'name'
  };

  Card.prototype.events = {
    'click': '_showContact'
  };

  Card.prototype.render = function() {
    this.$el.html(this.template());
    this.stickit();
    return this;
  };

  Card.prototype._showContact = function() {
    return router.navigate("#/contacts/" + this.model.id, {
      trigger: true
    });
  };

  return Card;

})(CompositeView);

module.exports = Card;
});

;require.register("views/contact", function(exports, require, module) {
var CompositeView, ContactView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CompositeView = require('lib/composite_view');

ContactView = (function(_super) {
  __extends(ContactView, _super);

  function ContactView() {
    return ContactView.__super__.constructor.apply(this, arguments);
  }

  ContactView.prototype.template = require('templates/contact');

  ContactView.prototype.id = 'contact';

  ContactView.prototype.addressBindings = {
    '#street': 'street',
    '#city': 'city',
    '#state': 'state',
    '#postcode': 'postcode'
  };

  ContactView.prototype.bindings = {
    '#age': 'age',
    '#avatar': {
      attributes: [
        {
          name: 'src',
          observe: 'gravatar_hash',
          onGet: function(val) {
            return "http://www.gravatar.com/avatar/" + val + "?d=mm&s=256";
          }
        }
      ]
    },
    '#birthday': {
      observe: 'birthday',
      onGet: function(val) {
        if (val) {
          return moment(val).format('M / D / YYYY');
        }
      }
    },
    '#email': 'email',
    '#name': 'name',
    '#phone': 'phone',
    '#sex': 'sex'
  };

  ContactView.prototype.events = {
    'click #edit': '_editContact'
  };

  ContactView.prototype.tooltipOptions = {
    placement: 'right',
    delay: {
      show: 500,
      hide: 100
    }
  };

  ContactView.prototype.render = function() {
    this.$el.html(this.template());
    this.stickit();
    this.stickit(this.model.get('address'), this.addressBindings);
    this._enableTooltips();
    return this;
  };

  ContactView.prototype._editContact = function() {
    return require('router').navigate("#/contacts/" + this.model.id + "/edit", {
      trigger: true
    });
  };

  ContactView.prototype._enableTooltips = function() {
    return this.$('[data-toggle=tooltip]').tooltip(this.tooltipOptions);
  };

  return ContactView;

})(CompositeView);

module.exports = ContactView;
});

;require.register("views/contacts", function(exports, require, module) {
var Card, CompositeView, ContactsView, router,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Card = require('views/card');

CompositeView = require('lib/composite_view');

router = require('router');

ContactsView = (function(_super) {
  __extends(ContactsView, _super);

  function ContactsView() {
    return ContactsView.__super__.constructor.apply(this, arguments);
  }

  ContactsView.prototype.template = require('templates/contacts');

  ContactsView.prototype.initialize = function(options) {
    ContactsView.__super__.initialize.call(this, options);
    this.collection = require('collections/contacts');
    return this.listenTo(this.collection, 'sort', this._renderCollection);
  };

  ContactsView.prototype.events = {
    'click #new': function() {
      return router.navigate('#/contacts/new', {
        trigger: true
      });
    }
  };

  ContactsView.prototype.render = function() {
    this.$el.html(this.template());
    this._renderCollection();
    return this;
  };

  ContactsView.prototype._renderCollection = function() {
    this._removeChildren();
    return this.collection.each((function(_this) {
      return function(model) {
        return _this.$el.append(_this.renderChild(new Card({
          model: model
        })).el);
      };
    })(this));
  };

  return ContactsView;

})(CompositeView);

module.exports = ContactsView;
});

;require.register("views/main", function(exports, require, module) {
var CompositeView, ContactsView, Main,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CompositeView = require('lib/composite_view');

ContactsView = require('views/contacts');

Main = (function(_super) {
  __extends(Main, _super);

  function Main() {
    return Main.__super__.constructor.apply(this, arguments);
  }

  Main.prototype.template = require('templates/main');

  Main.prototype.render = function() {
    this.$el.html(this.template());
    this._renderContacts();
    return this;
  };

  Main.prototype._renderContacts = function() {
    return this.renderChild(new ContactsView({
      el: this.$('#contacts')
    }));
  };

  return Main;

})(CompositeView);

module.exports = new Main({
  el: $('body')
}).render();
});

;
//# sourceMappingURL=app.js.map